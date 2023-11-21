import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:frontend/classes/Data.dart';

class Localizer {
  static final Map<String, dynamic> _localizedValues = Data.localizations;

  static String localize(String key, String lang) {
    print("key: " + key);
    print("lang: " + lang);
    print("Result: " + _localizedValues[key][lang]);
    return _localizedValues[key][lang];
    // return _localizedValues[key];
  }
}

String Localize(String text) {
  //get defualt language
  String defaultLanguage = 'ilo';
  return Localizer.localize(text, defaultLanguage);
}
