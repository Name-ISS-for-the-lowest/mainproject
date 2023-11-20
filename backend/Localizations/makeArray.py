import json


def main():
    # load supported languages
    supported = getSupportedLanguages()

    print(supported)


def getSupportedLanguages():
    # read file supportedLanguages.json
    supported = []
    with open("supportedLanguages.json", "r", encoding="utf-8") as f:
        data = json.load(f)
    for item in data:
        supported.append(item["name"])
    return supported
    # return list of supported languages


main()
