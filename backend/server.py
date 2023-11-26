from fastapi import FastAPI, Request, Response, UploadFile
from fastapi.responses import JSONResponse, HTMLResponse
from classes.DBManager import DBManager
from JSONmodels.credentials import credentials
from JSONmodels.postid import postid
from JSONmodels.postsearch import postsearch
from JSONmodels.userinfo import userinfo
from classes.PasswordHasher import PassHasher
from classes.EmailSender import EmailSender
from starlette.middleware.base import BaseHTTPMiddleware
from classes.ImageHelper import ImageHelper
import json
import urllib.parse
from models.Post import Post
from models.Report import Report
from bson import ObjectId
import migrate
from classes.Translator import Translator
import adminManager


app = FastAPI(title="ISS App")
migrate.migrate()
# When we actaully go live, I'd probably comment the adminManager out since we dont need to run it everytime server starts, only when changes to admin are made
adminManager.setAdmins()


class CookiesMiddleWare(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # pattern = r"^/.*$"
        if (
            request.url.path == "/login"
            or request.url.path == "/signup"
            or request.url.path == "/verify"
            or request.url.path == "/docs"
            or request.url.path == "/logout"
            or request.url.path == "/openapi.json"
        ):
            return await call_next(request)
        # check if the user has a cookie
        if "session_cookie" in request.cookies:
            cookie = request.cookies["session_cookie"]
            cookie = urllib.parse.unquote_plus(cookie)
            if DBManager.checkCookie(cookie):
                return await call_next(request)
            else:
                return JSONResponse(
                    content={"message": "You are not authorized"},
                    status_code=401,
                )
        else:
            return JSONResponse(
                content={"message": "You are not authorized"},
                status_code=401,
            )


def IdFromCookie(cookie):  # returns the user id from the cookie
    # parse json
    cookie = urllib.parse.unquote_plus(cookie)
    cookie = cookie.replace("'", '"')
    cookie = json.loads(cookie)
    id = ObjectId(cookie["user_id"])
    return id


app.add_middleware(CookiesMiddleWare)


@app.get("/")
def readRoot():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def readItem(item_id: int, q: str = None):
    return {"item_id": item_id, "q": q}


@app.post("/login")
def login(creds: credentials, request: Request, response: Response):
    email = creds.email
    password = creds.password
    user = DBManager.getUserByEmail(email)

    if user is None:
        print("user is none")
        return JSONResponse(
            content={"message": "Data does not match our records"}, status_code=400
        )
    else:
        if user["accountActivated"] == False:
            return JSONResponse(
                content={"message": "Data does not match our records"}, status_code=400
            )
        else:
            # we need to check the password
            passwordHash = user["passwordHash"]
            salt = user["salt"]
            # print(type(salt))
            # print(user.__dict__)
            print(PassHasher.checkPassword(password, passwordHash, salt))
            if PassHasher.checkPassword(password, passwordHash, salt):
                # check if the user has a cookie
                if "session_cookie" in request.cookies:
                    # check if the cookie is in the db
                    cookie = request.cookies["session_cookie"]
                    cookie = urllib.parse.unquote_plus(cookie)
                    print("cookie: ", cookie)
                    if DBManager.checkCookie(cookie):
                        return JSONResponse(
                            content={"message": "You are already logged in"},
                            status_code=400,
                        )

                # generate a session cookie for this user
                cookie = user.generateSecureCookie()
                # insert the cookie into the db to track session
                DBManager.insertCookie(cookie)

                # we need to convert the id to a string since it is a bson object
                cookie["_id"] = str(cookie["_id"])
                jsonCookie = json.dumps(cookie)
                encoded = urllib.parse.quote_plus(jsonCookie)

                # set response message
                response = JSONResponse(content={"message": "Login successful"})

                # set the cookie in the response
                response.set_cookie(
                    key="session_cookie",
                    value=(encoded),
                )
                return response
            else:
                return JSONResponse(
                    content={"message": "Data does not match our records"},
                    status_code=400,
                )


@app.post("/logout")
def logout(request: Request, response: Response):
    # check if the user has a cookie
    if "session_cookie" in request.cookies:
        # check if the cookie is in the db
        cookie = request.cookies["session_cookie"]
        cookie = urllib.parse.unquote_plus(cookie)
        if DBManager.checkCookie(cookie):
            # delete the cookie from the db
            DBManager.deleteCookie(cookie)
            # set response message
            response = JSONResponse(content={"message": "Logout successful"})
            # set the cookie in the response
            response.delete_cookie("session_cookie")
            return response
        else:
            return JSONResponse(
                content={"message": "You are not logged in"}, status_code=400
            )
    else:
        return JSONResponse(
            content={"message": "You are not logged in"}, status_code=400
        )


@app.post("/signup")
def signUp(creds: credentials):
    email = creds.email
    password = creds.password
    # check if the user already exists
    user = DBManager.getUserByEmail(email)
    if user is not None:
        return JSONResponse(
            content={"message": "Unable to create account"}, status_code=400
        )
    # create a new user
    salt = PassHasher.generateSalt()
    passwordHash = PassHasher.hashPassword(password, salt)
    # generate a token
    token = EmailSender.sendAuthenticationEmail(email)
    # insert the user into the db
    DBManager.insertUser(email, passwordHash, salt, token)
    return JSONResponse(
        content={"message": "Please verify your email"}, status_code=200
    )
    # send the user an email with the token


# todo change the url button so that it opens the app
# add ISS logo to email and page
@app.get("/verify")
def verifyAccount(token: str):
    # print("token: ", token)
    user = DBManager.getUserByToken(token)
    if user is None:
        return JSONResponse(
            content={"message": "Unable to verify account"}, status_code=400
        )
    else:
        DBManager.activateAccount(token)
        with open("verified.html") as f:
            html = f.read()
        return HTMLResponse(content=html, status_code=200)


@app.get("/protected")
def protected(request: Request):
    return {"message": "You are authorized"}


# I need to upload an actual endpoint for updating the profile picture
# it will be protected so I can use the cookie to get the userID, and change the url of the profile picture  in the db
# also add an optional signUp field for profile picture, and set it to the default profile picture
@app.post("/uploadPhoto")
async def uploadPhoto(photo: UploadFile, name: str, type:str):
    try:
        image = await ImageHelper.uploadImage(photo, name, type)
        print("image: ", image.__dict__)
        jsonImage = json.dumps(image.__dict__, ensure_ascii=False)

        return JSONResponse(content=image.__dict__, status_code=200)
    except Exception as e:
        print(e)
        return JSONResponse({"message": "Unable to upload photo"}), 400


@app.post("/createPost")
def createPost(postBody: str, request: Request):
    id = IdFromCookie(request.cookies["session_cookie"])
    DBManager.addPost(id, postBody)
    return JSONResponse({"message": "Post Added"}, status_code=200)


@app.post("/editPost")
def editPost(postID: str, postBody: str, request: Request):
    DBManager.editPost(postID, postBody)
    return JSONResponse({"message": "Post Edited"}, status_code=200)


@app.post("/deletePost")
def deletePost(postID: str, request: Request):
    DBManager.deletePost(postID)
    return JSONResponse({"message": "Post Deleted"}, status_code=200)


@app.post("/toggleRemovalOfPost")
def toggleRemovalOfPost(postID: str, request: Request):
    DBManager.toggleRemovalOfPost(postID)
    return JSONResponse({"message": "Removal Status Updated"}, status_code=200)


@app.get("/getPosts")
def getPosts(
    start: int,
    end: int,
    showReported: str,
    showRemoved: str,
    showDeleted: str,
    request: Request,
):
    userID = IdFromCookie(request.cookies["session_cookie"])
    # print("userID: ", userID)
    posts = DBManager.getPosts(
        start=start,
        end=end,
        showReported=showReported,
        showDeleted=showDeleted,
        showRemoved=showRemoved,
        userID=userID,
    )
    posts = Post.listToJson(posts)
    return posts

@app.get("/getPostByID")
def getPostByID(postID: str, request: Request):
    userID = IdFromCookie(request.cookies["session_cookie"])
    post = DBManager.getPostByID(postID)
    post = Post.toJson(post)
    return post


##if post is liked then it will unlike it
@app.post("/likePost", summary="Like a post, if already liked it will be unliked")
def likePost(postID: str, request: Request):
    userID = IdFromCookie(request.cookies["session_cookie"])
    response = DBManager.likePost(postID, userID)
    return JSONResponse(response, status_code=200)

@app.post("/reportPost", summary="Report a post")
def reportPost(postID: str, request: Request):
    userID = IdFromCookie(request.cookies["session_cookie"])
    response = DBManager.reportPost(postID, userID)
    return JSONResponse(response, status_code=200)


# both target and source are optional
# target language defaults to english
# source language can be infered
@app.get("/translate")
def translate(content: str, target: str = "en", source: str = ""):
    result = Translator.translate(content, target, source)
    # print("made it here")
    # print(result)
    return JSONResponse({"result": result}, status_code=200)


@app.post("/addTranslation")
def addTranslation(translatedText: str, userLang: str, postID: str, request: Request):
    DBManager.addTranslationToPost(
        translatedText=translatedText, userLang=userLang, postID=postID
    )
    return JSONResponse({"message": "Translation Added"}, status_code=200)


@app.get("/getUserByID", summary="A way to get a User's information by their ID")
def getUserByID(userID: str, request: Request):
    user = DBManager.getUserById(userID)
    pfpUrl = user.profilePicture["url"]
    pfpFileId = user.profilePicture["fileId"]
    userDict = user.__dict__
    returnedDict = {
        "_id": str(userDict["_id"]),
        "email": userDict["email"],
        "language": userDict["language"],
        "nationality": userDict["nationality"],
        "username": userDict["username"],
        "profilePicture.url": pfpUrl,
        "profilePicture.fileId": pfpFileId,
        "admin": str(userDict["admin"]),
    }
    return JSONResponse(content=returnedDict, status_code=200)


@app.post("/updateUser")
def updateUser(data: userinfo, request: Request):
    DBManager.updateUser(
        email=data.email,
        username=data.username,
        nationality=data.nationality,
        _id=data.id,
        language=data.language,
        profilePictureFileID=data.profilePictureFileID,
        profilePictureURL=data.profilePictureURL,
    )
    return JSONResponse(content="User Updated", status_code=200)


@app.post("/searchPosts", summary="Search Posts using a String input")
def searchPosts(data: postsearch):
    start = data.start
    end = data.end
    search = data.search
    userID = data.userID
    showReported = data.showReported
    showRemoved = data.showRemoved
    showDeleted = data.showDeleted
    posts = DBManager.searchPosts(
        start=start,
        end=end,
        search=search,
        showDeleted=showDeleted,
        showRemoved=showRemoved,
        showReported=showReported,
        userID=userID,
    )
    posts = Post.listToJson(posts)
    return posts


# get events
@app.get("/getEvents")
def getEvents(request: Request):
    # need to get the user language
    id = IdFromCookie(request.cookies["session_cookie"])
    user = DBManager.getUserById(id)
    language = user.language
    events = DBManager.getEvents(language)
    return events
