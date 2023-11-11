class Picture:
    url: str = "https://i.stack.imgur.com/SE2cv.jpg"
    fileId: str = "-1"

    def __init__(self, url="https://i.stack.imgur.com/SE2cv.jpg", fileId="-1"):
        if url is not None:
            self.url = url
        if fileId is not None:
            self.fileId = fileId

    @staticmethod
    def fromDict(dict):
        picture = Picture()
        for key in dict:
            setattr(picture, key, dict[key])
        return picture
