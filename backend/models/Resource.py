class Resource:
    name: str
    description: str
    link: str
    id: str

    def __init__(self, name, description, link):
        self.name = name
        self.description = description
        self.link = link
