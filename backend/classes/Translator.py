import requests
import os
from dotenv import load_dotenv

load_dotenv()

class Translator:
    @staticmethod
    def Translate():
        #make post to POST https://translation.googleapis.com/language/translate/v2
        apiKey = os.getenv("GOOGLE_API_KEY")
        reponse = requests.post("https://translation.googleapis.com/language/translate/v2")
        
