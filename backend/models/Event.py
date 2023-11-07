class Event:
    title: str
    date: str
    time: str
    location: str

    def __init__(self, title, date, time, location):
        self.title = title
        self.date = date
        self.time = time
        self.location = location

    @staticmethod
    def fromDict(dict):
        event = Event(dict["title"], dict["date"], dict["time"], dict["location"])
        for key in dict:
            setattr(event, key, dict[key])
        return event
