
from imagekitio import ImageKit
from imagekitio.models.UploadFileRequestOptions import UploadFileRequestOptions
from classes.ImageHelper import imagekit
import base64
import os
import base64
import asyncio

async def testUploadingImages():
    print('Check two')
    animals = ['dog', 'cat', 'monkey', 'shark', 'camel', 'giraffe', 'alpaca', 'rabbit', 'squirrel', 'turtle']
    for animal in animals:
        filePath = f'images/{animal}.jpg'
        with open(filePath, "rb") as file:
            imgstr = base64.b64encode(file.read()).decode("utf-8")
        upload = imagekit.upload_file(
            file=imgstr,
            file_name=animal,
            options=UploadFileRequestOptions(
                response_fields=["is_private_file", "custom_metadata", "tags"],
                folder="iss/" + 'testImages',
                is_private_file=False,
            ),
        )

async def main():
    print('Check one')
    await testUploadingImages()

asyncio.run(main())