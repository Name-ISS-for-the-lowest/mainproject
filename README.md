# ISS Main Project

Flutter project contains, models, and views.

    Models: classes such as Users, and other data structures
    Views: the app views

BackEnd Structure:

    Models: same thing as in the front end
    Classes: helper classes such as email sender
    JsonModels: might remove later

# Stuff:

I messed up in some of my naming, so you might see inconsistent camel casing.

Everything is oficially switched over to fastApi from Flask, the backend comes with a requirements.txt file, before you install everything I recommend you create a python venv by cd-ing into backend and running.

    python -m venv venv

then this to activate it

    . venv/Scripts/activate

then run this to install all the packages

    pip install -r requirements.txt

I made a makefile to run commands, it works on gitbash but if you're having trouble, just go into the Makefile and copy paste the commands.

to run the server

    make watch

or

    uvicorn index:app --reload

if you have trouble with Makefile.

This command will run the server and watch for changes on save, so you don't have to manually restart the server everytime.

# Tools:

I believe everyone got flutter setup, if you want to work on the backend you should also download:

    MongoDB
    MongoDB Compass
    Postman

# WSL

Unfortunatly Redis does not run on windows without WSL(windows subsystem for linux). Thinking we just forget about it for now, and in like three weeks when we worry about deployment, we might consider implementing it, since it is in the SDD. In the meantime, if you want you might consider getting WSL2 enabled and getting Ubuntu from the microsoft store.
