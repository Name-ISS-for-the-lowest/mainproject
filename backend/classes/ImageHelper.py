from imagekitio import ImageKit
from imagekitio.models.UploadFileRequestOptions import UploadFileRequestOptions
import base64
import os
from dotenv import load_dotenv
from models.Picture import Picture

load_dotenv()


imagekit = ImageKit(
    public_key=os.getenv("IMAGEKIT_PUBLIC_KEY"),
    private_key=os.getenv("IMAGEKIT_PRIVATE_KEY"),
    url_endpoint="https://ik.imagekit.io/dwjyllmmt/ISS",
)


class ImageHelper:
    # method should recieve an image file from an http response, that is able to
    # be encoded into base64
    # returns dict with url and fileId
    @staticmethod
    async def uploadImage(img, name, folder=""):
        imgstr = base64.b64encode(await img.read())
        upload = imagekit.upload_file(
            file=imgstr,
            file_name=name,
            options=UploadFileRequestOptions(
                response_fields=["is_private_file", "custom_metadata", "tags"],
                folder="iss/" + folder,
                is_private_file=False,
            ),
        )
        image = Picture(
            url=upload.response_metadata.raw["url"],
            fileId=upload.response_metadata.raw["fileId"],
        )

        return image

    @staticmethod
    def deleteImage(fileId):
        delete = imagekit.delete_file(fileId)
        return delete.response_metadata.raw
