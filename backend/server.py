from flask import Flask, request, jsonify, make_response
import json
from classes.EmailSender import EmailSender
from classes.PasswordHasher import PassHasher
from classes.DBManager import DBManager
from classes.ImageHelper import ImageHelper


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


@app.route("/signup", methods=["POST"])
def signUp():
    # get the data from the request
    data = request.get_json()
    email = data["email"]
    password = data["password"]
    # check if the email is already in the db
    user = DBManager.getUserByEmail(email)
    if user is not None:
        return jsonify({"message": "Unable to create account"}), 400

    # we create a salt and password hash
    salt = PassHasher.generate_salt()
    password_hash = PassHasher.hash_password(password, salt)

    # we need to send a verification email
    token = EmailSender.sendAuthenticationEmail(email)
    DBManager.insertUser(email, password_hash, salt, token)
    return jsonify({"message": "Please verify your email"}), 200


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
                # check if the user has a cookie
                if "session_cookie" in request.cookies:
                    # check if the cookie is in the db
                    cookie = request.cookies["session_cookie"]
                    if DBManager.checkCookie(cookie):
                        return jsonify({"message": "You are already logged in"}), 400

                # generate a session cookie for this user
                cookie = user.generateSecureCookie()
                # insert the cookie into the db to track session
                DBManager.insertCookie(cookie)

                # we need to convert the id to a string since it is a bson object
                cookie["_id"] = str(cookie["_id"])

                # set response message
                response = make_response(jsonify({"message": "Login successful"}))

                # set the cookie in the response
                stringCookie = json.dumps(cookie)
                response.set_cookie(
                    "session_cookie",
                    stringCookie,
                    expires=cookie["expires"],
                    secure=True,
                    httponly=True,
                )
                return response, 200
            else:
                return jsonify({"message": "Data does not match our records"}), 400


@app.route("/logout", methods=["GET"])
@check_session_cookie
def logout():
    # get the cookie from the request
    cookie = request.cookies["session_cookie"]
    # delete the cookie from the db
    DBManager.deleteCookie(cookie)
    # delete the cookie from the client
    response = make_response("Successfully logged out")
    response.set_cookie("session_cookie", "", expires=0)
    return response, 200


# example of a auth protected route
@app.route("/protected", methods=["GET"])
# this line is middleware that checks if the user is logged in
@check_session_cookie
def protected():
    return jsonify({"message": "You are authorized"}), 200


# example picture upload endpoint
@app.route("/uploadPhoto", methods=["POST"])
def uploadPhoto():
    print("here")
    try:
        uploadPhoto = request.files["photo"]
        image = ImageHelper.uploadeImage(uploadPhoto, "test")
        return jsonify(image), 200

    except Exception as e:
        print(e)
        return jsonify({"message": "Unable to upload photo"}), 400


# start the server
if __name__ == "__main__":
    app.run()
