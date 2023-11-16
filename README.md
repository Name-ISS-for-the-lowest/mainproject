# ISS Main Project

Our student made app, for international students at sac state.

# Set up

## create venv

Everything is oficially switched over to fastApi from Flask, the backend comes with a requirements.txt file, before you install everything I recommend you
create a python venv by cd-ing into backend and running.

    python -m venv venv

then this to activate it, commands will vary by the console you user

## Activate venv

### on windows 10:

    . venv/Scripts/activate

### on mac/linux:

    source venv/bin/activate

then run this to install all the packages

    pip install -r requirements.txt

I made a makefile to run commands, it works on gitbash but if you're having trouble, just go into the Makefile and copy paste the commands.

to run the server

    make watch

or

    uvicorn server:app --reload

if you have trouble with Makefile.

This command will run the server and watch for changes on save, so you don't have to manually restart the server everytime.

# Git commands

### Save progress to repo

    git add .

    git commit -m "your message"

    git push origin main

If you have already set up the upstream

    git push

### Warning

Avoid pushing to main/production until features are complete,
you should not be able to by default.
Avoid using -force commands as much as possible.

More questionable commands:

This command will override all your current changes and set your branch to main:
Do not run this unless you want to loose all your work.

    git reset --hard origin/main

# Running the project

Make sure you have everything installed in the backend and the front-end.

### Flutter packages

    make install

or the default command

    flutter pub get

### Start server:

from the backend folder

    make watch

or default

    uvicorn server:app --reload

### Run the app:

From the front end folder
I recommend using the using the debug button in vscode to run the flutter project, this will watch for changes automatically

### MongoDb and Compass

Ensure you have mongoDB running in the background, you should be able to open Compass and be able to connect to the default port.

### Check backend

To check if the backend is running you can try opening localhost:8000/docs on the browser;
Alternatively you can use Postman, to test each individual endpoint

# Current Progress

## Template Screen

![Template Screen](https://ik.imagekit.io/dwjyllmmt/iss/template.JPG?updatedAt=1699680004602)

## Login and SignUp

![Login](https://ik.imagekit.io/dwjyllmmt/iss/login.JPG?updatedAt=1699680004605)

![signup](https://ik.imagekit.io/dwjyllmmt/iss/signup.JPG?updatedAt=1699680004549)

## Activation Email

![signup](https://ik.imagekit.io/dwjyllmmt/iss/email.JPG?updatedAt=1699680103090)
