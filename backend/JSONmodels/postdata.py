from pydantic import BaseModel


class postdata(BaseModel):
    userID: str
    postBody: str
