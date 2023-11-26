import json
from datetime import datetime
import html
from bs4 import BeautifulSoup

monthsOfYear = {
    1: "JAN",
    2: "FEB",
    3: "MAR",
    4: "APR",
    5: "MAY",
    6: "JUN",
    7: "JUL",
    8: "AUG",
    9: "SEP",
    10: "OCT",
    11: "NOV",
    12: "DEC",
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
        htmlLocation = BeautifulSoup(dict["location"], "html.parser")
        realDate = datetime.strptime(date, "%Y-%m-%dT%H:%M:%S")
        event = Event()
        event.title = {
            "en": html.unescape(dict["title"]),
        }
        event.date = realDate
        event.day = realDate.strftime("%d")
        event.month = monthsOfYear[realDate.strftime("%b")]
        event.url = dict["permaLinkUrl"]
        event.description = {
            "en": htmlDesc.get_text(separator=" ", skipna=True),
        }
        event.location = {
            "en": htmlLocation.get_text(separator=" ", skipna=True),
        }
        for key in dict:
            setattr(event, key, dict[key])
        return event
