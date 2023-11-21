import requests
import os
from dotenv import load_dotenv
import json

load_dotenv()
apiKey = os.getenv("GOOGLE_API_KEY")


class Translator:
    @staticmethod
    def translate(content: str, target_language: str = "en", source_language: str = ""):
        url = (
            "https://translation.googleapis.com/language/translate/v2"
            + "?key="
            + apiKey
        )
        if source_language == "":
            source_language = Translator.infereLanguage(content)

        if source_language == target_language:
            return content
        results = requests.post(
            url,
            data={
                "q": content,
                "target": target_language,
                "source": source_language,
            },
        )
        return results.json()["data"]["translations"][0]["translatedText"]

    @staticmethod
    def infereLanguage(content: str):
        url = (
            "https://translation.googleapis.com/language/translate/v2/detect"
            + "?key="
            + apiKey
        )
        results = requests.post(
            url,
            data={
                "q": content,
            },
        )
        return results.json()["data"]["detections"][0][0]["language"]

    def getSupportedLanguages():
        url = (
            "https://translation.googleapis.com/language/translate/v2/languages"
            + "?key="
            + apiKey
        )
        results = requests.get(url)
        return results.json()["data"]["languages"]
