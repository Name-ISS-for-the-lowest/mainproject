from fastapi import FastAPI, Request, Response, UploadFile
from fastapi.responses import JSONResponse
from classes.DBManager import DBManager
from JSONmodels.credentials import credentials
from classes.PasswordHasher import PassHasher
from classes.EmailSender import EmailSender
from starlette.middleware.base import BaseHTTPMiddleware
from classes.ImageHelper import ImageHelper
import json


app = FastAPI()
# app.config["max_upload_size"] = 10 * 1024 * 1024


class CookiesMiddleWare(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
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
            if PassHasher.checkPassword(password, passwordHash, salt):
                # check if the user has a cookie
                if "session_cookie" in request.cookies:
                    # check if the cookie is in the db
                    cookie = request.cookies["session_cookie"]
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

                # set response message
                response = JSONResponse(content={"message": "Login successful"})

                # set the cookie in the response
                stringCookie = json.dumps(cookie)
                response.set_cookie(
                    "session_cookie",
                    stringCookie,
                    expires=cookie["expires"],
                    secure=True,
                    httponly=True,
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
def signUp(creds: credentials, request: Request, response: Response):
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


@app.get("/verify")
def verifyAccount(token: str):
    print("token: ", token)
    user = DBManager.getUserByToken(token)
    if user is None:
        return JSONResponse(
            content={"message": "Unable to verify account"}, status_code=400
        )
    else:
        DBManager.activateAccount(token)
        return JSONResponse(content={"message": "Account activated"}, status_code=200)


@app.get("/protected")
def protected(request: Request):
    return {"message": "You are authorized"}


@app.post("/uploadPhoto")
async def uploadPhoto(photo: UploadFile):
    print("file: ", photo)
    try:
        image = await ImageHelper.uploadImage(photo, "test")
        return JSONResponse(content=image, status_code=200)
    except Exception as e:
        print(e)
        return JSONResponse({"message": "Unable to upload photo"}), 400
