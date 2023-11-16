class Picture:
    url: str = "https://ik.imagekit.io/dwjyllmmt/iss/SE2cv.jpg"
    fileId: str = "-1"

    def __init__(
        self, url="https://ik.imagekit.io/dwjyllmmt/iss/SE2cv.jpg", fileId="-1"
    ):
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
