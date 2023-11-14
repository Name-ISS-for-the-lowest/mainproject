import pymongo
import json
from models.User import User
from models.Post import Post
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

    @staticmethod
    def getUserByToken(token):
        user = DBManager.db["users"].find_one({"token": token})
        if user is None:
            return None
        else:
            return User.fromDict(user)

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
    def addPost(userID, content):
        newPost = Post(content, userID)
        id = DBManager.db["posts"].insert_one(newPost.__dict__)

    @staticmethod
    def getPosts(start, end):
        posts = DBManager.db["posts"].find().sort("_id", -1).skip(start).limit(end)
        return_posts = []
        for elem in posts:
            return_posts.append(Post.fromDict(elem))
        return return_posts

    # db.collection.find({
    #   "date": { $lt: endDate }
    # }).sort({"timestamp": -1}).limit(25)

    def insertUserList(users: [User]):
        for user in users:
            userJson = user.__dict__
            DBManager.db["users"].insert_one(userJson)

    @staticmethod
    def insertPostList(posts: [Post]):
        for post in posts:
            postJson = post.__dict__
            postJson["user_id"] = ObjectId(postJson["user_id"]["$oid"])
            DBManager.db["posts"].insert_one(postJson)
