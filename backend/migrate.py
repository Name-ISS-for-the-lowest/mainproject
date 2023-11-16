import json
from classes.DBManager import DBManager
from models.User import User
from models.Post import Post
import base64
import datetime
from bson import ObjectId
from classes.DBManager import DBManager


def insertUserList(users: [User]):
    for user in users:
        userJson = user.__dict__
        DBManager.db["users"].update_one(
            {"email": userJson["email"]}, {"$set": userJson}, upsert=True
        )


def insertPostList(posts: [Post]):
    for post in posts:
        postJson = post.__dict__
        postJson["user_id"] = ObjectId(postJson["user_id"]["$oid"])
        postJson["_id"] = ObjectId(postJson["_id"]["$oid"])
        DBManager.db["posts"].update_one(
            {"_id": postJson["_id"]},
            {"$set": postJson},
            upsert=True,
        )


def insertUsers():
    # get users from json file
    file = open("users.json")
    data = json.load(file)
    # turn the data into user object
    for i in range(len(data)):
        data[i] = User.fromDict(data[i])
        salt_data = data[i]["salt"]
        base64_string = salt_data["$binary"]["base64"]
        salt_bytes = base64.b64decode(base64_string)
        data[i].salt = salt_bytes
        data[i]._id = ObjectId(data[i]._id["$oid"])
        data[i].username = data[i].email.split("@")[0]
    insertUserList(data)


def insertPosts():
    file = open("posts.json")
    data = json.load(file)
    # turn the data into user object
    for i in range(len(data)):
        data[i] = Post.fromDict(data[i])
        user = DBManager.getUserById(ObjectId(data[i].user_id["$oid"]))
        data[i].username = user.username
        data[i].profilePicture = user.profilePicture
        # turn date into datetime object
        # data[i].date = datetime.datetime.strptime(data[i].date, "%Y-%m-%d %H:%M:%S.%f")
        data[i].date = datetime.datetime.strptime(
            data[i].date["$date"], "%Y-%m-%dT%H:%M:%S.%fZ"
        )
    insertPostList(data)


def migrate():
    insertUsers()
    insertPosts()
    print("Successfully migrated data to MongoDB!")
