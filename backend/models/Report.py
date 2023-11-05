import datetime


class Report:
    user_id: str
    post_id: str
    date: datetime.datetime
    reason: str

    def __init__(self, user_id, post_id, reason):
        self.user_id = user_id
        self.post_id = post_id
        self.date = datetime.datetime.now()
        self.reason = reason

    def fromDict(dict):
        report = Report(dict["user_id"], dict["post_id"], dict["reason"])
        for key in dict:
            setattr(report, key, dict[key])
        return report
