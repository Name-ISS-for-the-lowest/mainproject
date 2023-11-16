from pydantic import BaseModel


class postfetcher(BaseModel):
    start: int
    end: int
