import pymongo
import json
from models.User import User
from models.Post import Post
from models.Picture import Picture
import bson
from bson import ObjectId, binary, BSON
import base64


class DBManager:
    host = "mongodb://localhost:27017/"
    client = pymongo.MongoClient(host)
    db = client["ISSDB"]

    @staticmethod
    def insertUser(email, passwordHash, salt, token):
        new_user = User(email, passwordHash, salt, token)
        print(new_user.__dict__)
        print("here")
        id = DBManager.db["users"].insert_one(new_user.__dict__)
        print("id: ", id.inserted_id)

    @staticmethod
    def getUserByEmail(email):
        # turn the user into a class instance
        user = DBManager.db["users"].find_one({"email": email})
        if user is None:
            return None
        else:
            return User.fromDict(user)
        
   # def resetUserPassword(email, new_password):


    @staticmethod
    def getUserByToken(token):
        user = DBManager.db["users"].find_one({"token": token})
        if user is None:
            return None
        else:
            return User.fromDict(user)

    @staticmethod
    def getUserById(id):
        if isinstance(id, str):
            id = ObjectId(id)
        user = DBManager.db["users"].find_one({"_id": id})
        if user is None:
            return None
        else:
            return User.fromDict(user)

    @staticmethod
    def updateUser(
        email: str,
        username: str,
        _id: str,
        language: str,
        nationality: str,
        profilePictureURL: str,
        profilePictureFileID: str,
    ):
        id = ObjectId(_id)
        user = DBManager.db["users"].find_one({"_id": id})
        fields = ["email", "username", "language", "nationality"]
        newDict = {}
        for elem in fields:
            if user.get(elem) != vars()[elem]:
                newDict[elem] = vars()[elem]
        profilePicture = user.get("profilePicture")
        oldProfilePicture = profilePicture.copy()
        if (
            profilePicture["url"] != profilePictureURL
            or profilePicture["fileId"] != profilePictureFileID
        ):
            profilePictureHistory = user.get("profilePictureHistory")
            profilePictureHistory.append(oldProfilePicture)
            profilePicture["url"] = profilePictureURL
            profilePicture["fileId"] = profilePictureFileID
            newDict["profilePicture"] = profilePicture
            newDict["profilePictureHistory"] = profilePictureHistory
        oldUsername = user.get("username")
        if oldUsername != username:
            usernameHistory = user.get("usernameHistory")
            usernameHistory.append(oldUsername)
            newDict["usernameHistory"] = usernameHistory
        DBManager.db["users"].update_one({"_id": id}, {"$set": newDict})

    @staticmethod
    def activateAccount(token):
        DBManager.db["users"].update_one(
            {"token": token}, {"$set": {"accountActivated": True}}
        )
        # let's delete the token so they don't keep using it
        DBManager.db["users"].update_one({"token": token}, {"$unset": {"token": ""}})

    @staticmethod
    def insertCookie(cookie):
        DBManager.db["session_cookies"].insert_one(cookie)

    @staticmethod
    def checkCookie(cookie):
        # parse json
        cookie = cookie.replace("'", '"')
        cookie = json.loads(cookie)

        # check if the cookie is in the db
        cookie = DBManager.db["session_cookies"].find_one(
            {"session_id": cookie["session_id"]}
        )
        if cookie is None:
            return False
        else:
            return True

    @staticmethod
    def deleteCookie(cookie):
        # parse json
        cookie = cookie.replace("'", '"')
        cookie = json.loads(cookie)
        # delete the cookie from the db
        DBManager.db["session_cookies"].delete_one({"session_id": cookie["session_id"]})

    @staticmethod
    def addPost(userID, content, imageURL, imageFileID):
        newPost = Post(content, userID)
        if imageURL != "False":
            Attachment = Picture(imageURL, imageFileID)
            newPost.attachedImage = Attachment.__dict__
        user = DBManager.getUserById(userID)
        DBManager.db["posts"].insert_one(newPost.__dict__)

    @staticmethod
    def editPost(postID, postBody):
        postID = ObjectId(postID)
        post = DBManager.db["posts"].find_one({"_id": postID})
        contentHistory = post.get("contentHistory")
        currentContent = post.get("content")
        if postBody == currentContent:
            translations = post.get("translations")
        else:
            translations = {}
        contentHistory.append(currentContent)
        DBManager.db["posts"].update_one(
            {"_id": postID},
            {
                "$set": {
                    "edited": True,
                    "content": postBody,
                    "contentHistory": contentHistory,
                    "translations": translations,
                }
            },
        )

    @staticmethod
    def deletePost(postID):
        postID = ObjectId(postID)
        DBManager.db["posts"].update_one({"_id": postID}, {"$set": {"deleted": True}})

    @staticmethod
    def toggleRemovalOfPost(postID, forceRemove):
        postID = ObjectId(postID)
        post = DBManager.db["posts"].find_one({"_id": postID})
        isRemoved = post.get("removed")
        removalToggle = not isRemoved
        if forceRemove == 'Remove':
            DBManager.db["posts"].update_one(
            {"_id": postID}, {"$set": {"removed": True}}
        )
        elif forceRemove == 'Approve':
            DBManager.db["posts"].update_one(
            {"_id": postID}, {"$set": {"removed": False}}
        )
        else:
            DBManager.db["posts"].update_one(
                {"_id": postID}, {"$set": {"removed": removalToggle}}
            )

    @staticmethod
    def getPosts(start, end, showRemoved, showDeleted, showReported, userID=None):
        specialSearchParams = {}
        if showRemoved == "Only":
            specialSearchParams["removed"] = True
        elif showRemoved == "None":
            specialSearchParams["removed"] = False
        if showDeleted == "Only":
            specialSearchParams["deleted"] = True
        elif showDeleted == "None":
            specialSearchParams["deleted"] = False
        posts = (
            DBManager.db["posts"]
            .find(specialSearchParams)
            .sort("_id", -1)
            .skip(start)
            .limit(end)
        )
        returnPosts = []
        for elem in posts:
            post = Post.fromDict(elem)
            user = DBManager.db["users"].find_one({"_id": ObjectId(post.userID)})
            post.profilePicture = user.get("profilePicture")
            post.username = user.get("username")
            post.posterIsAdmin = user.get("admin")
            post.email = user.get("email")
            comboID = str(post._id) + str(userID)
            likedResult = DBManager.db["likes"].find_one({"comboID": comboID})
            reportedResult = DBManager.db["reports"].find_one({"comboID": comboID})
            if likedResult is not None:
                post.liked = True
            if reportedResult is not None:
                post.reportedByUser = True

            returnPosts.append(post)
        return returnPosts

    @staticmethod
    def getPostByID(postID: str):
        objectID = ObjectId(postID)
        post = DBManager.db["posts"].find_one({"_id": objectID})
        user = DBManager.db["users"].find_one({"_id": ObjectId(post["userID"])})
        post["profilePicture"] = user["profilePicture"]
        post["username"] = user["username"]
        post["posterIsAdmin"] = user["admin"]
        post["email"] = user["email"]
        comboID = str(post["_id"]) + str(post["userID"])
        likedResult = DBManager.db["likes"].find_one({"comboID": comboID})
        reportedResult = DBManager.db["reports"].find_one({"comboID": comboID})
        if likedResult is not None:
            post["liked"] = True
        if reportedResult is not None:
            post["reportedByUser"] = True
        returnPost = Post.fromDict(post)
        return returnPost

    @staticmethod
    def searchPosts(start, end, showRemoved, showDeleted, showReported, search, userID):
        specialSearchParams = {"content": {"$regex": search, "$options": "i"}}
        if showRemoved == "Only":
            specialSearchParams["removed"] = True
        elif showRemoved == "None":
            specialSearchParams["removed"] = False
        if showDeleted == "Only":
            specialSearchParams["deleted"] = True
        elif showDeleted == "None":
            specialSearchParams["deleted"] = False
        posts = (
            DBManager.db["posts"]
            .find(specialSearchParams)
            .sort("_id", -1)
            .skip(start)
            .limit(end)
        )
        returnPosts = []
        for elem in posts:
            post = Post.fromDict(elem)
            user = DBManager.db["users"].find_one({"_id": ObjectId(post.userID)})
            post.profilePicture = user.get("profilePicture")
            post.username = user.get("username")
            post.posterIsAdmin = user.get("admin")
            comboID = str(post._id) + str(userID)
            likedResult = DBManager.db["likes"].find_one({"comboID": comboID})
            if likedResult is not None:
                post.liked = True
            returnPosts.append(post)
        return returnPosts

    @staticmethod
    def likePost(postID, userID):
        # check if the user has already liked the post
        comboID = str(postID) + str(userID)
        postID = ObjectId(postID)
        likedResult = DBManager.db["likes"].find_one({"comboID": comboID})
        if likedResult is None:
            # increment the likes
            result = DBManager.db["posts"].update_one(
                {"_id": postID}, {"$inc": {"likes": 1}}
            )
            print(result.modified_count)

            # add the like to the likes collection
            DBManager.db["likes"].insert_one({"comboID": comboID})
            print("liked")
            return {"message": "Post liked"}
        else:
            # decrement the likes
            DBManager.db["posts"].update_one({"_id": postID}, {"$inc": {"likes": -1}})
            # remove the like from the likes collection
            DBManager.db["likes"].delete_one({"comboID": comboID})
            return {"message": "Post unliked"}

    @staticmethod
    def reportPost(postID, userID, specialDict):
        # check if the user has already liked the post
        comboID = str(postID) + str(userID)
        postID = ObjectId(postID)
        reportResult = DBManager.db["reports"].find_one({"comboID": comboID})
        postResult = DBManager.db["posts"].find_one({"_id": postID})
        reasonDict = postResult.get("reportReasons")
        if reportResult is None:
            postDict = {"reports": 1}
            reasons = [
                "hateSpeech",
                "illegalContent",
                "targetedHarassment",
                "inappropriateContent",
                "otherReason",
            ]
            for reason in reasons:
                if specialDict[reason]:
                    reasonDict[reason] += 1
            result = DBManager.db["posts"].update_one(
                {"_id": postID}, {"$inc": {"reports": 1}}
            )
            result2 = DBManager.db["posts"].update_one(
                {"_id": postID},
                {"$set": {"reportReasons": reasonDict, "unreviewedReport": True}},
            )
            print(result.modified_count)

            # add the reports to the reports collection
            DBManager.db["reports"].insert_one(
                {"PostID": postID, "comboID": comboID, "Reason": "harassment"}
            )
            print("Reported")
            return {"message": "Post reported"}
        else:
            return {"message": "Post already reported"}

    @staticmethod
    def addTranslationToPost(translatedText, userLang, postID):
        result = DBManager.db["posts"].update_one(
            {"_id": ObjectId(postID)},
            {"$set": {f"translations.{userLang}": translatedText}},
        )
        # print(result.matched_count)
        if result.matched_count == 1:
            return {"message": "Translation added"}
        else:
            return {"message": "Post not found"}

    def insertUserList(users: [User]):
        for user in users:
            userJson = user.__dict__
            DBManager.db["users"].insert_one(userJson)

    def setAdmins(adminEmails):
        allUsers = DBManager.db["users"].find()
        for user in allUsers:
            userEmail = user["email"]
            isAdmin = False
            if userEmail in adminEmails:
                isAdmin = True
            DBManager.db["users"].update_one(
                {"_id": user["_id"]}, {"$set": {"admin": isAdmin}}
            )
        print("Admin privilleges assigned successfully!")

    @staticmethod
    def insertPostList(posts: [Post]):
        for post in posts:
            postJson = post.__dict__
            postJson["userID"] = ObjectId(postJson["userID"]["$oid"])
            DBManager.db["posts"].insert_one(postJson)

    # @staticmethod
    # def getEvents(language: str):
    #     # I first, fetch all events from the database, trimming all events older than today
    #     # I check if the event has been translated to the user's language, if not, I translate them
    #     # I then return the events
    #     events = DBManager.db["events"].find()
    #     returnEvents = []
    #     for elem in events:
    #         returnEvents.append(elem)
    #     return returnEvents
