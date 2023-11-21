import 'dart:convert';
import 'dart:io';
import 'package:recase/recase.dart';
import 'package:frontend/languagePicker/languages.dart';

toGetterName(String languageName) => languageName
    // Remove commas and parentheses
    .replaceAll(RegExp('[,\(\)]'), '')
    // Replace punctuated name
    .replaceAll('ü', 'u')
    .camelCase;

/// Reads languages.json and generates lib/languages.g.dart, which contains
/// Languages.countryName constants and the Languages.defaultLanguages list.
main() {
  final contents = File('lib/languages.json').readAsStringSync();
  final jsonLanguages = jsonDecode(contents);
  final List<Language> languages = jsonLanguages
      .map<Language>((m) => Language.fromMap(Map<String, String>.from(m)))
      .toList();
  final getters = languages.map((l) {
    final getterName = toGetterName(l.name);
    return "  static Language get $getterName => Language('${l.isoCode}', '${l.name}');";
  });

  final defaultLanguages = '''
static List<Language> defaultLanguages =
  [${languages.map((l) => 'Languages.' + toGetterName(l.name)).join(',\n')}];
''';

  final staticClass = '''
// This is a generated file. See DEVELOPMENT_NOTES.md.
import 'languages.dart';

class Languages {
${getters.join('\n')}

$defaultLanguages
}
''';
  File('lib/languagePicker/languages.g.dart').writeAsStringSync(staticClass);
}
