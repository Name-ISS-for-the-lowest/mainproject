Powershell -Command "& {%LocalAppData%\MongoDBCompass\MongoDBCompass.exe;venv/Scripts/Activate.ps1; uvicorn server:app --reload;}"

pause