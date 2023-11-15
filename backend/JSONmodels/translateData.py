from pydantic import BaseModel


class translateData(BaseModel):
    source: str
    target: str
    content: str