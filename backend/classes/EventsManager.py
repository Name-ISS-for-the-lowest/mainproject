import requests
import json
from models.Event import Event


class EventsManager:
    @staticmethod
    def getEvents():
        # make fetch request to get events
        response = requests.get(
            "https://www.trumba.com/calendars/sacramento-state-events.json"
        )
        events = response.json()
        eventObjects = []
        for event in events:
            eventObjects.append(Event.fromDict(event))

    @staticmethod
    def translateEvents(lang: str, events: list[Event]):
        print("translateEvents")
