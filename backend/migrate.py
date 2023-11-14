import json
from classes.DBManager import DBManager
from models.User import User
from models.Post import Post
import base64
import datetime
from bson import ObjectId


# def insertUsers():
#     # get users from json file
#     file = open("users.json")
#     data = json.load(file)
#     # turn the data into user object
#     for i in range(len(data)):
#         data[i] = User.fromDict(data[i])
#         salt_data = data[i]["salt"]
#         base64_string = salt_data["$binary"]["base64"]
#         salt_bytes = base64.b64decode(base64_string)
#         data[i].salt = salt_bytes
#         data[i]._id = ObjectId(data[i]._id["$oid"])
#     DBManager.insertUserList(data)


# insertUsers()


def insertPosts():
    file = open("posts.json")
    data = json.load(file)
    # turn the data into user object
    for i in range(len(data)):
        data[i] = Post.fromDict(data[i])
        # turn date into datetime object
        # data[i].date = datetime.datetime.strptime(data[i].date, "%Y-%m-%d %H:%M:%S.%f")
        data[i].date = datetime.datetime.strptime(
            data[i].date["$date"], "%Y-%m-%dT%H:%M:%S.%fZ"
        )
        print(data[i].date)
    DBManager.insertPostList(data)


insertPosts()
