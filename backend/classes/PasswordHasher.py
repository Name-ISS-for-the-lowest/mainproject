import bcrypt
import hashlib
from argon2 import PasswordHasher


# static class for hashing passwords
class PassHasher:
    # private method
    @staticmethod
    def _fastHash(password):
        return hashlib.sha512(password.encode("utf-8")).hexdigest()

    @staticmethod
    def hashPassword(password, salt):
        fastHash = PassHasher._fastHash(password)
        ph = PasswordHasher()
        return ph.hash(fastHash, salt=salt)

    @staticmethod
    def checkPassword(password, hashed, salt):
        newHash = PassHasher.hashPassword(password, salt)
        return newHash == hashed

    @staticmethod
    def generate_salt():
        return bcrypt.gensalt()
