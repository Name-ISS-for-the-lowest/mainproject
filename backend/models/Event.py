import json
from datetime import datetime
import html
from bs4 import BeautifulSoup

monthsOfYear = {
    "01": "JAN",
    "02": "FEB",
    "03": "MAR",
    "04": "APR",
    "05": "MAY",
    "06": "JUN",
    "07": "JUL",
    "08": "AUG",
    "09": "SEP",
    "10": "OCT",
    "11": "NOV",
    "12": "DEC",
}


class Event:
    title: {str, str}
    date: str
    location: {str, str}
    day: str
    month: str
    url: str
    description: {str, str}

    @staticmethod
    def fromDict(dict):
        date = dict["startDateTime"]
        htmlDesc = BeautifulSoup(dict["description"], "html.parser")
        htmlDesc = html.unescape(htmlDesc.get_text(separator=" "))
        htmlLocation = BeautifulSoup(dict["location"], "html.parser")
        realDate = datetime.strptime(date, "%Y-%m-%dT%H:%M:%S")
        event = Event()
        event.title = {
            "en": html.unescape(dict["title"]),
        }
        event.date = {
            "en": html.unescape(dict["dateTimeFormatted"]),
        }
        event.day = realDate.strftime("%d")
        event.month = monthsOfYear[realDate.strftime("%m")]
        event.url = dict["permaLinkUrl"]
        event.description = {
            "en": htmlDesc,
        }
        event.location = htmlLocation.get_text(separator=" ")
        # for key in dict:
        #     setattr(event, key, dict[key])
        return event

    @staticmethod
    def listToDics(events: list):
        jsonEvents = []
        for event in events:
            jsonEvents.append(event.__dict__)
        return jsonEvents
