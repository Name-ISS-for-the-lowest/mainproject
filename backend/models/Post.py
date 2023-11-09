# this is the users post
import datetime


class Post:
    content: str
    user_id: str
    date: datetime.datetime
    likes: int
    imagelinks: list

    def __init__(self, content, user_id, parent_id=None):
        self.content = content
        self.user_id = user_id
        self.date = datetime.datetime.now()
        self.likes = 0
        # if parent is none then post is not a reply
        # otherwise the post is a reply to parent
        self.parent_id = parent_id

    @staticmethod
    def fromDict(dict):
        post = Post(dict["content"], dict["user_id"])
        for key in dict:
            setattr(post, key, dict[key])
        return post
