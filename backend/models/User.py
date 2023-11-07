import secrets
import datetime
from bson import ObjectId


class User:
    # to-do add default values

    def __init__(self, email, passwordHash, salt, token=None):
        self.email = email
        self.passwordHash = passwordHash
        self.salt = salt
        self.token = token
        self.accountActivated = False

    @staticmethod
    def fromDict(dict):
        # turn a dictionary into a class instance
        user = User(dict["email"], dict["password_hash"], dict["salt"])
        if "token" in dict:
            user.token = dict["token"]
        for key in dict:
            setattr(user, key, dict[key])
        return user

    def generateSecureCookie(self):
        # generate a secure cookie
        # add the user id, session id, and expiration date

        # set expiration date 30 days from now
        expiration = datetime.datetime.now() + datetime.timedelta(days=30)
        expiration_string = expiration.strftime("%a, %d %b %Y %H:%M:%S GMT")
        id = str(self._id)

        cookie = {
            "user_id": id,
            "session_id": User.generateRandomId(30),
            "expires": expiration_string,
        }
        # we need to add the cookie to the cookie sessions collection
        return cookie

    def __getitem__(self, key):
        # this allows us to access the class attributes like a dictionary
        return getattr(self, key)

    @staticmethod
    def generateRandomId(length):
        # generate a random id of a given length
        return secrets.token_urlsafe(length)
