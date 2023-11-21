import sys
import json
import re

sys.path.append("..")  # Adds higher directory to python modules path.

from classes.Translator import Translator


def main():
    # get supported languages, as list of string
    supported = getSupportedLanguages()
    appText = getAppText()

    localizationsMap = {}
    mapOfAllLanguages = {}

    for language in supported:
        mapOfAllLanguages[language] = ""

    for item in appText:
        # add to map
        localizationsMap[item] = mapOfAllLanguages.copy()

    niceJson = json.dumps(localizationsMap, indent=4, sort_keys=True)

    for item in localizationsMap:
        for language in localizationsMap[item]:
            localizationsMap[item][language] = translateFromEnglishTo(item, language)

    niceJson = json.dumps(localizationsMap, indent=4, sort_keys=True)

    with open("localizations.json", "w", encoding="utf-8") as f:
        f.write(niceJson)


def translateFromEnglishTo(content: str, target: str):
    return Translator.translate(content, target, "en")


def getSupportedLanguages():
    # read file supportedLanguages.json
    supported = []
    with open("supportedLanguages.json", "r", encoding="utf-8") as f:
        data = json.load(f)
    for item in data:
        supported.append(item["language"])
    return supported
    # return list of supported languages


def getAppText():
    # read file appText.json
    with open("appText.json", "r", encoding="utf-8") as f:
        data = json.load(f)
    array = data["data"]
    newAppText = []
    for item in array:
        item = re.sub(r"[^\x00-\x7F]+", "", item)
        newAppText.append(item)
    return newAppText
    # return json object


if __name__ == "__main__":
    main()
