# # need to generate random users
# # generate 20 random users

from models.User import User
from classes.PasswordHasher import PassHasher
from models.Picture import Picture
from models.Post import Post
from classes.DBManager import DBManager
import requests
import random
from bson import ObjectId, json_util
import json
import lorem
import pymongo


# names = [
#     "Mr.Whiskers",
#     "Good_Boy",
#     "Kevin",
#     "Mochi",
#     "Max",
#     "Gizmo",
#     "Cleo",
#     "Milo",
#     "Luna",
#     "Bella",
#     "Misty",
#     "Rocky",
#     "Jasper",
#     "Tango",
#     "Oliver",
#     "Rosie",
#     "Charlie",
#     "Coco",
#     "Duke",
#     "Zoey",
# ]

# languages = [
#     "English",
#     "Spanish",
#     "French",
#     "Japanese",
#     "Russian",
#     "German",
#     "Italian",
#     "Mandarin",
#     "Arabic",
#     "Portuguese",
#     "Dutch",
#     "Swahili",
#     "Korean",
#     "Hindi",
#     "Turkish",
#     "Swedish",
#     "Greek",
#     "Finnish",
#     "Hebrew",
#     "Thai",
# ]

# countries = [
#     "United States",
#     "Canada",
#     "Brazil",
#     "Australia",
#     "India",
#     "France",
#     "Japan",
#     "Russia",
#     "South Africa",
#     "Mexico",
#     "Germany",
#     "Italy",
#     "China",
#     "Argentina",
#     "Spain",
#     "Egypt",
#     "Norway",
#     "South Korea",
#     "Nigeria",
#     "New Zealand",
# ]


# class GeneratedUser(User):
#     username: str
#     password: str = "Password1"
#     email: str = "john.doe@example.com"

#     # inherit init but add password
#     def __init__(self, language, nationality, name):
#         self.username = name
#         salt = PassHasher.generateSalt()
#         passwordHash = PassHasher.hashPassword(GeneratedUser.password, salt)
#         super().__init__(GeneratedUser.email, passwordHash, salt)
#         self.language = language
#         self.nationality = nationality
#         self.profilePicture = GeneratedUser.retrieveRandomPicture(name).__dict__
#         self._id = ObjectId()

#     @staticmethod
#     def retrieveRandomPicture(name):
#         # generate a 1 or a 0umbe
#         rand = random.randint(0, 1)
#         randomUrl = ""
#         if rand == 0:
#             randomUrl = GeneratedUser.retrieveRandomCatPictureUrl()
#         else:
#             randomUrl = GeneratedUser.retrieveRandomDogPictureUrl()

#         response = requests.get(randomUrl)
#         if response.status_code == 200:
#             files = {"photo": ("photo.jpg", response.content, "image/jpeg")}
#             # upload file to imagekit
#             url = "http://localhost:8000/uploadPhoto/?name=" + name
#             response = requests.post(
#                 url,
#                 files=files,
#             )
#             return Picture.fromDict(response.json())
#         else:
#             return Picture()

#     @staticmethod
#     def retrieveRandomCatPictureUrl():
#         ## use http to fetch https://api.thecatapi.com/v1/images/search
#         ## return the url of the image
#         url = "https://api.thecatapi.com/v1/images/search"
#         headers = {"accept": "application/json"}

#         response = requests.get(url, headers=headers)

#         if response.status_code == 200:
#             data = response.json()
#             return data[0]["url"]
#         else:
#             print("Error: ", response.status_code)
#             return None

#     @staticmethod
#     def retrieveRandomDogPictureUrl():
#         url = "https://dog.ceo/api/breeds/image/random"
#         headers = {"accept": "application/json"}

#         goodUrl = False

#         while goodUrl == False:
#             response = requests.get(url, headers=headers)
#             if response.status_code == 200:
#                 data = response.json()
#                 returnUrl = data["message"]
#                 goodUrl = GeneratedUser.checkUrl(returnUrl)
#                 if goodUrl == True:
#                     return returnUrl
#             else:
#                 print("Error: ", response.status_code)

#     @staticmethod
#     def checkUrl(url):
#         ##check if url returns a 200
#         response = requests.get(url)
#         print(response.status_code)
#         if response.status_code == 200:
#             return True
#         else:
#             return False


# class GeneratedPost(Post):
#     def __init__(self, content, user_id, parent_id=None):
#         super().__init__(content, user_id, parent_id)

#     @staticmethod
#     def getUsers():
#         # get all users from the json file
#         with open("users.json") as file:
#             data = json.load(file)
#             # turn the data into user object
#             for i in range(len(data)):
#                 data[i] = GeneratedUser.fromDict(data[i])
#             return data


# GeneratedPost.users = GeneratedPost.getUsers()


# ## I need to insert all users and posts into the database
# ## I need to generate random posts for each user


# def insertUsers():
#     # get users from json file
#     file = open("users.json")
#     data = json.load(file)
#     # turn the data into user object
#     for i in range(len(data)):
#         data[i] = GeneratedUser.fromDict(data[i])
#     DBManager.insertUserList(data)


# insertUsers()


# def updatePosts():
#     ##get posts json file
#     file = open("posts.json")
#     data = json.load(file)
#     for i in range(len(data)):
#         data[i] = Post.fromDict(data[i])
#         data[i]._id = ObjectId()
#         # turn id's to json
#         data[i]._id = {"$oid": str(data[i]._id)}
#     # print(data[0].__dict__)
#     # # turn the data back into a json object
#     dicts = []
#     for post in data:
#         dicts.append(post.__dict__)
#     print(dicts[0])
#     # save json object to file
#     with open("posts1.json", "w") as file:
#         json.dump(dicts, file)


# updatePosts()
