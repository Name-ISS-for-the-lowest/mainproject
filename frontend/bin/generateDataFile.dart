import 'dart:convert';
import 'dart:io';

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

main() async {
  Map<String, dynamic> localizations =
      await jsonDecode(File('bin/localizations.json').readAsStringSync());

  String dartFileContent =
      generateDartFileContent(localizations, languageNames);
  File('lib/classes/Data.dart').writeAsStringSync(dartFileContent);
}

String generateDartFileContent(
    Map<String, dynamic> localizations, Map<String, dynamic> languageNames) {
  // Start building the Dart file content
  String dartFileContent = 'class Data {\n';

  // Add each map as a static variable in the Data class
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');

  String jsonLocalizations = encoder.convert(localizations);
  String jsonLanguageNames = encoder.convert(languageNames);

  dartFileContent +=
      '  static Map<String, dynamic> localizations = $jsonLocalizations;\n';
  dartFileContent +=
      '  static Map<String, dynamic> languageNames = $jsonLanguageNames;\n';

  // Close the Data class
  dartFileContent += '}';

  return dartFileContent;
}

String _formatMap(Map<String, dynamic> map) {
  // Format the map with double quotes around keys and string values
  String formattedMap = '{' +
      map.entries
          .map((entry) => '"${entry.key}": ${_formatValue(entry.value)}')
          .join(', ') +
      '}';
  return formattedMap;
}

String _formatValue(dynamic value) {
  // Format the value with double quotes if it's a string
  return value is String ? '"$value"' : value.toString();
}
