import secrets
import datetime
from classes.DBManager import DBManager


class User:
    accountActivated = False
    # to-do add default values

    def __init__(self, name, email, password_hash, salt, token):
        self.name = name
        self.email = email
        self.password_hash = password_hash
        self.salt = salt
        self.token = token

    @staticmethod
    def fromDict(dict):
        User(
            dict["name"],
            dict["email"],
            dict["password_hash"],
            dict["salt"],
            dict["token"],
        )
        User.accountActivated = dict["accountActivated"]
        User._id = dict["_id"]
        return User

    def generateSecureCookie(self):
        # generate a secure cookie
        # add the user id, session id, and expiration date

        # set expiration date 30 days from now
        expiration = datetime.datetime.now() + datetime.timedelta(days=30)
        expiration_string = expiration.strftime("%a, %d %b %Y %H:%M:%S GMT")
        cookie = {
            "user_id": self._id,
            "session_id": User.generateRandomId(30),
            "expires": expiration_string,
        }
        # we need to add the cookie to the cookie sessions collection
        DBManager.insertCookie(cookie)
        return cookie

    @staticmethod
    def generateRandomId(length):
        # generate a random id of a given length
        return secrets.token_urlsafe(length)
