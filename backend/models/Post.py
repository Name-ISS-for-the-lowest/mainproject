# this is the users post
import datetime
import json
from bson import ObjectId
from models.Picture import Picture


class Post:
    content: str
    userID: str
    username: str
    email: str
    profilePicture = Picture()
    attachedImage = Picture()
    date: datetime.datetime
    likes: int
    comments: int
    reports: int
    imagelinks: list
    liked: bool = False
    reportedByUser: bool = False
    edited: bool
    deleted: bool
    removed: bool
    contentHistory: list
    translations: dict
    posterIsAdmin: bool = False
    posterIsBanned: bool = False
    reports: int
    imageURL: str
    fileId: str
    reportReasons: dict
    unreviewedReport: bool = False

    def __init__(self, content, user_id, attachment=None, parent_id=None):
        self.content = content
        self.userID = user_id
        self.date = datetime.datetime.now()
        self.likes = 0
        self.comments = 0
        self.reports = 0
        self.liked = False
        self.reportedByUser = False
        self.posterIsAdmin = False
        self.posterIsBanned = False
        # if parent is none then post is not a reply
        # otherwise the post is a reply to parent
        self.parent_id = parent_id
        self.translations = {}
        self.edited = False
        self.contentHistory = []
        self.reportReasons = {
            "hateSpeech": 0,
            "targetedHarassment": 0,
            "illegalContent": 0,
            "inappropriateContent": 0,
            "otherReason": 0,
        }
        self.deleted = False
        self.removed = False
        self.reports = 0
        self.unreviewedReport = False
        if attachment == None:
            attachment = "Empty"
        self.attachedImage = attachment
        if attachment != None and attachment != "Empty":
            self.imageURL = attachment.url
            self.fileId = attachment.fileID
        else:
            self.imageURL = None
            self.fileId = None

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
    def toJson(post, targetLang=None):
        # turn all to string
        post.date = str(post.date)
        post._id = str(post._id)
        post.userID = str(post.userID)
        post.edited = str(post.edited)
        post.deleted = str(post.deleted)
        post.removed = str(post.removed)
        post.reports = str(post.reports)
        post.posterIsAdmin = str(post.posterIsAdmin)
        print(targetLang)
        if targetLang != None:
            if targetLang in post.translations:
                print(targetLang)
                post.translations = str(post.translations[targetLang])
            else:
                post.translations = ""
            return post.__dict__

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
            post.reports = str(post.reports)
            post.posterIsAdmin = str(post.posterIsAdmin)
            post = Post.toJson(post, targetLang=targetLang)
        return posts
