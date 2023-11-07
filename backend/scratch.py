# this file is for trying out code snippets
# I want to upload a file to imagekit.io
from imagekitio import ImageKit
from imagekitio.models.UploadFileRequestOptions import UploadFileRequestOptions
import base64
import os

import sys
from dotenv import load_dotenv

load_dotenv()


imagekit = ImageKit(
    public_key=os.getenv("IMAGEKIT_PUBLIC_KEY"),
    private_key=os.getenv("IMAGEKIT_PRIVATE_KEY"),
    url_endpoint="https://ik.imagekit.io/dwjyllmmt/ISS",
)

with open("images\harambe.webp", mode="rb") as img:
    imgstr = base64.b64encode(img.read())


upload = imagekit.upload_file(
    file=imgstr,
    file_name="harambe",
    options=UploadFileRequestOptions(
        response_fields=["is_private_file", "custom_metadata", "tags"],
        folder="iss/",
        is_private_file=False,
    ),
)


# this is appeneded to url to resize image ?tr=w-400,h-400,,fo-face
# fo-face autocrops to face
# fo-auto smart generally fo-auto is best
image = {
    "url": upload.response_metadata.raw["url"],
    "fileId": upload.response_metadata.raw["fileId"],
}

print(image)


# delete = imagekit.delete_file(upload.response_metadata.raw["fileId"])


# print(delete.response_metadata.raw)
