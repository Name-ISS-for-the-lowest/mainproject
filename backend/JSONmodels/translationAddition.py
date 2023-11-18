from pydantic import BaseModel


class translationAddition(BaseModel):
    translatedText: str
    userLang: str
    postID: str
