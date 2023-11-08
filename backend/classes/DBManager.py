import pymongo
import json
from models.User import User


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
        cookie = json.loads(cookie)
        # delete the cookie from the db
        DBManager.db["session_cookies"].delete_one({"session_id": cookie["session_id"]})
