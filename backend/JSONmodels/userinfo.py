from pydantic import BaseModel


class userinfo(BaseModel):
    id : str
    email : str
    username : str
    language : str
    nationality : str
    profilePictureURL : str
    profilePictureFileID: str