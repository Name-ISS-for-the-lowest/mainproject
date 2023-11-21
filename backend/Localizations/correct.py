import json
import re


# Adds higher directory to python modules path.
import sys

sys.path.append("..")
from classes.Translator import Translator


def main():
    # first get localizations.json
    allLanguages = []

    with open("allLanguages.json", "r", encoding="utf-8") as f:
        data = json.load(f)
        allLanguages = data

    with open("corrections.json", "r", encoding="utf-8") as f:
        data = json.load(f)
    for item in data:
        for language in allLanguages:
            if data[item][language] == "Error":
                data[item][language] = translateFromEnglishTo(item, language)
                niceJson = json.dumps(data, indent=4, sort_keys=True)
                with open("corrections.json", "w", encoding="utf-8") as f:
                    f.write(niceJson)


def translateFromEnglishTo(content: str, target: str):
    try:
        print("success" + content + " Target: " + target)
        results = Translator.translate(content, target, "en")
        print(results)
        return results
    except Exception as e:
        print("Content: " + content + " Target: " + target)
        print(e)
        return "Error"


main()
