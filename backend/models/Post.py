# this is the users post
import datetime
import json
from bson import ObjectId
from models.Picture import Picture


class Post:
    content: str
    user_id: str
    username: str
    profilePicture = Picture()
    date: datetime.datetime
    likes: int
    imagelinks: list
    liked: bool = False
    edited: bool
    deleted: bool
    contentHistory: []
    translations: {}

    def __init__(self, content, user_id, parent_id=None):
        self.content = content
        self.user_id = user_id
        self.date = datetime.datetime.now()
        self.likes = 0
        self.liked = False
        # if parent is none then post is not a reply
        # otherwise the post is a reply to parent
        self.parent_id = parent_id
        self.translations = {}
        self.edited = False
        self.contentHistory = []
        self.deleted = False

    @staticmethod
    def fromDict(dict):
        post = Post(dict["content"], dict["user_id"])
        for key in dict:
            setattr(post, key, dict[key])
        return post
    
    @staticmethod
    def contentHistoryToString(post):
        if len(post.contentHistory) == 0:
            return '[]'
        else:
            history = '['
            i = 0
            for elem in post.contentHistory:
                history += elem
                if i != len(post.contentHistory):
                    history += ','
                i += 1
            history += ']'
        return history

    @staticmethod
    def toJson(post):
        # turn all to string
        post.date = str(post.date)
        post._id = str(post._id)
        post.user_id = str(post.user_id)
        post.edited = str(post.edited)
        post.contentHistory = Post.contentHistoryToString(post)
        post.deleted = str(post.deleted)
        return json.dumps(post.__dict__)

    @staticmethod
    def listToJson(posts, targetLang=None):
        # turn all to string
        for post in posts:
            post.date = str(post.date)
            post._id = str(post._id)
            post.user_id = str(post.user_id)
            post.edited = str(post.edited)
            post.contentHistory = Post.contentHistoryToString(post)
            post.deleted = str(post.deleted)
            if targetLang in post.translations:
                post.translations = str(post.translations[targetLang])
            else:
                post.translations = ""
            post = Post.toJson(post)
        return posts
