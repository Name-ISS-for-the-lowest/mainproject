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
        return eventObjects

    @staticmethod
    def translateEvents(lang: str, events: list[Event]):
        if lang == "en":
            return Event.listToDics(events)
        listOfStrings = []
        for event in events:
            listOfStrings.append(event.title["en"])
            listOfStrings.append(event.date["en"])
            listOfStrings.append(event.description["en"])
        for i, item in enumerate(listOfStrings):
            # print("|", item, "|")
            if item == "":
                # print("empty string")
                listOfStrings[i] = "NONE"
        # print(listOfStrings)

        jsonData = json.dumps(
            {
                "stringList": listOfStrings,
            }
        )
        try:
            results = requests.post(
                "https://issapp.gabrielmalek.com/bulkTranslate?target=" + lang,
                data=jsonData,
                headers={
                    "Content-Type": "application/json",
                },
            )
            finalList = results.json()["result"]
            for event in events:
                event.title[lang] = finalList.pop(0)
                event.date[lang] = finalList.pop(0)
                event.description[lang] = finalList.pop(0)

            # save the events to json file
            jsonEvents = Event.listToDics(events)
            return jsonEvents
            # break
        except Exception as e:
            print("failed on ", e)
            exit()
