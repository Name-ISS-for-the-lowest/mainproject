from pydantic import BaseModel


class postsearch(BaseModel):
    start: str
    end: int
    search: str
    userID : str
    showReported: str
    showDeleted: str
    showRemoved: str
