# this is the users post
import datetime
import json
from bson import ObjectId
from models.Picture import Picture


class Post:
    content: str
    userID: str
    username: str
    profilePicture = Picture()
    date: datetime.datetime
    likes: int
    reports: int
    imagelinks: list
    liked: bool = False
    edited: bool
    deleted: bool
    removed: bool
    contentHistory: []
    translations: {}
    posterIsAdmin: bool

    def __init__(self, content, user_id, parent_id=None):
        self.content = content
        self.userID = user_id
        self.date = datetime.datetime.now()
        self.likes = 0
        self.reports = 0
        self.liked = False
        # if parent is none then post is not a reply
        # otherwise the post is a reply to parent
        self.parent_id = parent_id
        self.translations = {}
        self.edited = False
        self.contentHistory = []
        self.deleted = False
        self.removed = False

    @staticmethod
    def fromDict(dict):
        post = Post(dict["content"], dict["userID"])
        for key in dict:
            setattr(post, key, dict[key])
        return post

    @staticmethod
    def contentHistoryToString(post):
        print(post.contentHistory)
        if len(post.contentHistory) == 0:
            return "[]"
        else:
            history = "["
            i = 1
            for elem in post.contentHistory:
                history += elem
                if i != len(post.contentHistory):
                    history += ","
                i += 1
            history += "]"
        return history

    @staticmethod
    def toJson(post):
        # turn all to string
        post.date = str(post.date)
        post._id = str(post._id)
        post.userID = str(post.userID)
        post.edited = str(post.edited)
        post.contentHistory = Post.contentHistoryToString(post)
        post.deleted = str(post.deleted)
        post.removed = str(post.removed)
        post.posterIsAdmin = str(post.posterIsAdmin)
        return json.dumps(post.__dict__)

    @staticmethod
    def listToJson(posts, targetLang=None):
        # turn all to string
        for post in posts:
            post.date = str(post.date)
            post._id = str(post._id)
            post.userID = str(post.userID)
            post.edited = str(post.edited)
            post.deleted = str(post.deleted)
            post.removed = str(post.removed)
            post.posterIsAdmin = str(post.posterIsAdmin)
            if targetLang in post.translations:
                post.translations = str(post.translations[targetLang])
            else:
                post.translations = ""
            post = Post.toJson(post)
        return posts
