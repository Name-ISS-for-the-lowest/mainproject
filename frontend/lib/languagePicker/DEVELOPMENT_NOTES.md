# Development notes

## Regenerate languages

If you modify languages.json, you should regenerate the language constants in
languages.g.dart by running:

```
flutter pub pub run language_picker:build_languages
dart format lib/languages.g.dart
```
