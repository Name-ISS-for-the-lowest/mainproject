import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:frontend/classes/authHelper.dart';

import 'package:frontend/classes/Data.dart';

class Localizer {
  static final Map<String, dynamic> _localizedValues = Data.localizations;

  static String localize(String key, String lang) {
    return _localizedValues[key][lang];
    // return _localizedValues[key];
  }
}

String Localize(String text) {
  //get defualt language
  String defaultLanguage = 'en';
  print("User language: ");
  print(AuthHelper.userInfoCache);
  if (AuthHelper.userInfoCache['language'] != null) {
    defaultLanguage = AuthHelper.userInfoCache['language'];
  }

  return Localizer.localize(text, defaultLanguage);
}
