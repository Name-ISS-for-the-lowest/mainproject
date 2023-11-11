import json
from classes.DBManager import DBManager
from models.User import User
from models.Post import Post


def insertUsers():
    # get users from json file
    file = open("users.json")
    data = json.load(file)
    # turn the data into user object
    for i in range(len(data)):
        data[i] = User.fromDict(data[i])
    DBManager.insertUserList(data)


insertUsers()


def insertPosts():
    file = open("posts.json")
    data = json.load(file)
    # turn the data into user object
    for i in range(len(data)):
        data[i] = Post.fromDict(data[i])
    DBManager.insertPostList(data)


insertPosts()
