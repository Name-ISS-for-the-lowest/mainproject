from pydantic import BaseModel


class postsearch(BaseModel):
    start: int
    end: int
    search: str
    userID : str
