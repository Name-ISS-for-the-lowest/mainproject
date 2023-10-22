from flask import Flask, request, jsonify, make_response
import json
from classes.EmailSender import EmailSender
from classes.PasswordHasher import PassHasher
from classes.DBManager import DBManager


app = Flask(__name__)
app.config["SESSION_COOKIE_SECURE"] = True


# middleware to check if the user is logged in
def check_session_cookie(func):
    def wrapper(*args, **kwargs):
        # check if the cookie is set
        if "session_cookie" in request.cookies:
            # check if the cookie is in the db
            cookie = request.cookies["session_cookie"]
            if DBManager.checkCookie(cookie):
                return func(*args, **kwargs)
            else:
                return jsonify({"message": "Unauthorized"}), 401
        else:
            return jsonify({"message": "Unauthorized"}), 401

    wrapper.__name__ = func.__name__
    return wrapper


@app.route("/signUp", methods=["POST"])
def signUp():
    # get the data from the request
    data = request.get_json()
    email = data["email"]
    password = data["password"]

    # we create a salt and password hash
    salt = PassHasher.generate_salt()
    password_hash = PassHasher.hash_password(password, salt)

    # we need to send a verification email
    token = EmailSender.sendAuthenticationEmail(email)
    DBManager.insertUser(email, password_hash, salt, token)


@app.route("/verify", methods=["GET"])
def verify():
    # get the token from the url
    token = request.args.get("token")
    user = DBManager.getUserByToken(token)
    if user is None:
        return jsonify({"message": "Invalid token"}), 400
    else:
        # activate the account
        DBManager.activateAccount(token)
        # lto-do return an html page that says the account has been activated
        return jsonify({"message": "Account activated"}), 200


@app.route("/login", methods=["POST"])
def login():
    # we need to verify that the account is activated
    data = request.get_json()
    email = data["email"]
    password = data["password"]
    user = DBManager.getUserByEmail(email)
    if user is None:
        return jsonify({"message": "Data does not match our records"}), 400
    else:
        if user["accountActivated"] == False:
            return jsonify({"message": "Please activate account"}), 400
        else:
            # we need to check the password
            password_hash = user["password_hash"]
            salt = user["salt"]
            if PassHasher.check_password(password, password_hash, salt):
                # to-do return a secure cookie
                cookie = user.generateSecureCookie()
                response = make_response("Cookie is set")
                response.set_cookie(
                    "session_cookie",
                    cookie,
                    expires=cookie["expires"],
                    secure=True,
                    httponly=True,
                )
                return response, 200
            else:
                return jsonify({"message": "Data does not match our records"}), 400


def main():
    # test password hasher
    salt = PassHasher.generate_salt()
    password = "password"
    password_hash = PassHasher.hash_password(password, salt)
    print(password_hash)
    print(PassHasher.check_password(password, password_hash, salt))


main()
