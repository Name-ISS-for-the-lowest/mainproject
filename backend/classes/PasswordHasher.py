import bcrypt
import random
import string
import hashlib
from argon2 import PasswordHasher


# static class for hashing passwords
class PassHasher:
    # private method
    @staticmethod
    def _fast_Hash(password):
        return hashlib.sha512(password.encode("utf-8")).hexdigest()

    @staticmethod
    def hash_password(password, salt):
        fast_hash = PassHasher._fast_Hash(password)
        ph = PasswordHasher()
        return ph.hash(fast_hash, salt=salt)

    @staticmethod
    def check_password(password, hashed, salt):
        newHash = PassHasher.hash_password(password, salt)
        return newHash == hashed

    @staticmethod
    def generate_salt():
        return bcrypt.gensalt()
