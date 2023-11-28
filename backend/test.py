from classes.EventsManager import EventsManager
import json


result = EventsManager.getEvents()
prettyJson = EventsManager.translateEvents("es", result)
print(prettyJson)
