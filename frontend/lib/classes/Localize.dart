import 'dart:ui';
import 'dart:ui' as ui;
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/Data.dart';

class Localizer {
  static final Map<String, dynamic> _localizedValues = Data.localizations;

  static String localize(String key, String lang) {
    //check if key exists
    if (!_localizedValues.containsKey(key)) {
      //send error
      throw Exception(
          'Key |$key| not found, please add your text to bin/appText.json and run ```dart run bin/generate.dart```');
    }
    return _localizedValues[key][lang];
    // return _localizedValues[key];
  }
}

String Localize(String text) {
  //get defualt language
  Locale systemLocale = ui.window.locale;
  String defaultLanguage = systemLocale.languageCode;
  if (AuthHelper.userInfoCache['language'] != null) {
    defaultLanguage = AuthHelper.userInfoCache['language'];
  }

  return Localizer.localize(text, defaultLanguage);
}
