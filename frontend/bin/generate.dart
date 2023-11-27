import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

Map<String, dynamic> languageNames = {
  'af': 'Afrikaans',
  'sq': 'Albanian',
  'am': 'Amharic',
  'ar': 'Arabic',
  'hy': 'Armenian',
  'as': 'Assamese',
  'ay': 'Aymara',
  'az': 'Azerbaijani',
  'bm': 'Bambara',
  'eu': 'Basque',
  'be': 'Belarusian',
  'bn': 'Bengali',
  'bho': 'Bhojpuri',
  'bs': 'Bosnian',
  'bg': 'Bulgarian',
  'ca': 'Catalan',
  'ceb': 'Cebuano',
  'ny': 'Chichewa',
  'zh': 'Chinese (Simplified)',
  'zh-TW': 'Chinese (Traditional)',
  'co': 'Corsican',
  'hr': 'Croatian',
  'cs': 'Czech',
  'da': 'Danish',
  'dv': 'Divehi',
  'doi': 'Dogri',
  'nl': 'Dutch',
  'en': 'English',
  'eo': 'Esperanto',
  'et': 'Estonian',
  'ee': 'Ewe',
  'tl': 'Filipino',
  'fi': 'Finnish',
  'fr': 'French',
  'fy': 'Frisian',
  'gl': 'Galician',
  'lg': 'Ganda',
  'ka': 'Georgian',
  'de': 'German',
  'el': 'Greek',
  'gn': 'Guarani',
  'gu': 'Gujarati',
  'ht': 'Haitian Creole',
  'ha': 'Hausa',
  'haw': 'Hawaiian',
  'iw': 'Hebrew',
  'hi': 'Hindi',
  'hmn': 'Hmong',
  'hu': 'Hungarian',
  'is': 'Icelandic',
  'ig': 'Igbo',
  'ilo': 'Iloko',
  'id': 'Indonesian',
  'ga': 'Irish Gaelic',
  'it': 'Italian',
  'ja': 'Japanese',
  'jw': 'Javanese',
  'kn': 'Kannada',
  'kk': 'Kazakh',
  'km': 'Khmer',
  'rw': 'Kinyarwanda',
  'gom': 'Konkani',
  'ko': 'Korean',
  'kri': 'Krio',
  'ku': 'Kurdish (Kurmanji)',
  'ckb': 'Kurdish (Sorani)',
  'ky': 'Kyrgyz',
  'lo': 'Lao',
  'la': 'Latin',
  'lv': 'Latvian',
  'ln': 'Lingala',
  'lt': 'Lithuanian',
  'lb': 'Luxembourgish',
  'mk': 'Macedonian',
  'mai': 'Maithili',
  'mg': 'Malagasy',
  'ms': 'Malay',
  'ml': 'Malayalam',
  'mt': 'Maltese',
  'mi': 'Maori',
  'mr': 'Marathi',
  'mni-Mtei': 'Meiteilon (Manipuri)',
  'lus': 'Mizo',
  'mn': 'Mongolian',
  'my': 'Myanmar (Burmese)',
  'ne': 'Nepali',
  'nso': 'Northern Sotho',
  'no': 'Norwegian',
  'or': 'Odia (Oriya)',
  'om': 'Oromo',
  'ps': 'Pashto',
  'fa': 'Persian',
  'pl': 'Polish',
  'pt': 'Portuguese',
  'pa': 'Punjabi',
  'qu': 'Quechua',
  'ro': 'Romanian',
  'ru': 'Russian',
  'sm': 'Samoan',
  'sa': 'Sanskrit',
  'gd': 'Scots Gaelic',
  'sr': 'Serbian',
  'st': 'Sesotho',
  'sn': 'Shona',
  'sd': 'Sindhi',
  'si': 'Sinhala',
  'sk': 'Slovak',
  'sl': 'Slovenian',
  'so': 'Somali',
  'es': 'Spanish',
  'su': 'Sundanese',
  'sw': 'Swahili',
  'sv': 'Swedish',
  'tg': 'Tajik',
  'ta': 'Tamil',
  'tt': 'Tatar',
  'te': 'Telugu',
  'th': 'Thai',
  'ti': 'Tigrinya',
  'ts': 'Tsonga',
  'tr': 'Turkish',
  'tk': 'Turkmen',
  'ak': 'Twi',
  'uk': 'Ukrainian',
  'ur': 'Urdu',
  'ug': 'Uyghur',
  'uz': 'Uzbek',
  'vi': 'Vietnamese',
  'cy': 'Welsh',
  'xh': 'Xhosa',
  'yi': 'Yiddish',
  'yo': 'Yoruba',
  'zu': 'Zulu',
  'he': 'Hebrew',
  'jv': 'Javanese',
  'zh-CN': 'Chinese (Simplified)'
};

int totalSteps = languageNames.length;
int currentStep = 0;
main() async {
  //read content of appText.json
  final List<dynamic> appText =
      await jsonDecode(File('bin/appText.json').readAsStringSync());
  Map<String, dynamic> localizations =
      await jsonDecode(File('bin/localizations.json').readAsStringSync());

  Map<String, String> mapOfLanguages = {};
  languageNames.forEach((key, value) {
    mapOfLanguages[key] = "";
  });

  List<String> listOfLanguages = [];
  languageNames.forEach((key, value) {
    listOfLanguages.add(key);
  });

  //loop thru each key in localizations
  List wordsToAdd = [];
  List wordsToRemove = [];
  for (var value in appText) {
    //check if key exists in appText
    if (!localizations.containsKey(value)) {
      //add key to appText
      wordsToAdd.add(value);
    }
  }
  for (var key in localizations.keys) {
    //check if key exists in appText
    if (!appText.contains(key)) {
      wordsToRemove.add(key);
    }
  }
  for (var key in wordsToRemove) {
    localizations.remove(key);
  }

  if (wordsToRemove.isNotEmpty && wordsToAdd.isEmpty) {
    print("Words removed: ${wordsToRemove.length}");
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String formattedJson = encoder.convert(localizations);
    File('bin/localizations.json').writeAsStringSync(formattedJson);
    return;
  }

  if (wordsToAdd.isEmpty) {
    print("No new words to add");
    return;
  }

  //set up map of languages
  for (var element in wordsToAdd) {
    localizations[element] = {...mapOfLanguages};
  }

  var start = DateTime.now();
  print(
      "Generating translations, please wait a moment, flutter is single treaded and a bit slower than the python implementation");
  List<Future<void>> futures = [];
  for (var language in listOfLanguages) {
    futures.add(languageTranslations(wordsToAdd, language, localizations));
  }
  await Future.wait(futures);
  updateProgressBar(totalSteps, totalSteps);
  //save localizations to json file
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String formattedJson = encoder.convert(localizations);
  File('bin/localizations.json').writeAsStringSync(formattedJson);
  //run generateDataFile.dart
  var result = await Process.run('dart', ['bin/generateDataFile.dart']);
  print(result.stdout);
  print('Exit code: ${result.exitCode}');
  var end = DateTime.now();
  print("\nWords added: ${wordsToAdd.length}");
  print("Words removed: ${wordsToRemove.length}");
  print("Time taken: ${end.difference(start).inSeconds}s");

  //now I want to generate the file data.dart in lib/classes it is simply a class called data with 2 maps
}

Future<void> languageTranslations(wordsToAdd, language, finalMap) async {
  bool completed = false;
  List translatedList = await translateListFromEnglishTo(wordsToAdd, language);
  int maxTries = 50;
  while (!completed) {
    maxTries--;
    if (maxTries == 0) {
      throw Exception(
          "Max tries reached on language: $language please try again in a few minutes");
    }
    if (translatedList[0] == "Error") {
      translatedList = await translateListFromEnglishTo(wordsToAdd, language);
    } else {
      completed = true;
      updateProgressBar(currentStep, totalSteps);
      currentStep++;
      // print("Completed language: $language");
    }
  }
  for (var i = 0; i < translatedList.length; i++) {
    finalMap[wordsToAdd[i]][language] = translatedList[i];
  }
}

translateListFromEnglishTo(List appText, String language) async {
  //need to make a request to my endpoint
  if (language == "en") {
    return appText;
  }

  String url = "https://issapp.gabrielmalek.com/bulkTranslate";
  final params = {'target': language};
  //this is the dio library making a post request
  var data = {
    "stringList": appText,
  };

  final dio = Dio();
  try {
    final response = await dio.post(
      url,
      data: jsonEncode(data),
      queryParameters: params,
      options: Options(contentType: Headers.jsonContentType),
    );
    var result = jsonDecode(response.toString());
    return result['result'];

    //on anything but a 200 response this code will run
  } on DioException {
    //return array of Error string
    // print("ERROR: $e $language");
    List returnArray = [];
    for (var element in appText) {
      returnArray.add("Error");
    }
    return returnArray;
  }
}

void updateProgressBar(int currentStep, int totalSteps) {
  const int progressBarLength = 20;
  final double progress = currentStep / totalSteps;
  final int filledLength = (progress * progressBarLength).round();

  // Build the progress bar string
  final String progressBar = "Current Progress[${"=" * filledLength}${" " * (progressBarLength - filledLength)}] ${(progress * 100).toStringAsFixed(1)}%";

  // Print the progress bar on the same line
  stdout.write('\r$progressBar');
}
