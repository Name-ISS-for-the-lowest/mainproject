# ISS Main Project

Flutter project contains, models, and views.

    Models: classes such as Users, and other data structures
    Views: the app views

BackEnd Structure:

    Models: same thing as in the front end
    Classes: helper classes such as email sender
    JsonModels: might remove later

More:
What we have so far for implementation, I messed up in some of my naming, I changed them but missed a few so you might see some random method that is not camel case, if you change it on your branch it might be a problem when trying to merge.

    Everything is oficially switched everything over to fastApi from Flask, the backend comes with a requirements.txt file, before you install everything I recommend you create a python venv by cd-ing into backend and running.

    ```python -m venv venv```

    then this to activate it

    ```. venv/Scripts/activate```

    then run this to install all the packages

    ```pip install -r requirements.txt```


    I made a makefile to run commands, it works on gitbash but if you're having trouble, just go into the Makefile and copy paste the commands.

    to run the server

    ```make watch```

    or


    ```uvicorn index:app --reload```

    if you have trouble with Makefile.

    This command will run the server and watch for changes on save, so you don't have to manually restart the server everytime.
