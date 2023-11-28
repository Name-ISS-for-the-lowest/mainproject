import 'package:frontend/languagePicker/language_picker_dropdown_controller.dart';
import 'package:frontend/languagePicker/languages.dart';
import 'package:frontend/languagePicker/utils/typedefs.dart';
import 'package:flutter/material.dart';

///Provides a customizable [DropdownButton] for all languages
class LanguagePickerDropdown extends StatefulWidget {
  const LanguagePickerDropdown(
      {super.key, this.itemBuilder,
      this.controller,
      this.initialValue,
      this.onValuePicked,
      this.languages});

  ///This function will be called to build the child of DropdownMenuItem
  ///If it is not provided, default one will be used which displays
  ///flag image, isoCode and phoneCode in a row.
  ///Check _buildDefaultMenuItem method for details.
  final ItemBuilder? itemBuilder;

  ///Preselected language.
  final Language? initialValue;

  ///This function will be called whenever a Language item is selected.
  final ValueChanged<Language>? onValuePicked;

  /// An optional controller.
  final LanguagePickerDropdownController? controller;

  /// List of languages available in this picker.
  final List<Language>? languages;

  @override
  _LanguagePickerDropdownState createState() => _LanguagePickerDropdownState();
}

class _LanguagePickerDropdownState extends State<LanguagePickerDropdown> {
  late List<Language> _languages;
  late Language _selectedLanguage;

  @override
  void initState() {
    _languages = widget.languages ?? Languages.defaultLanguages;
    if (widget.initialValue != null) {
      try {
        _selectedLanguage = _languages
            .firstWhere((language) => language == widget.initialValue!);
      } catch (error) {
        throw Exception(
            "The initialValue is missing from the list of displayed languages!");
      }
    } else if (widget.controller != null) {
      _selectedLanguage = widget.controller!.value;
    } else {
      _selectedLanguage = _languages[0];
    }

    widget.controller?.addListener(() {
      setState(() {
        _selectedLanguage = widget.controller!.value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Language>> items = _languages
        .map((language) => DropdownMenuItem<Language>(
            value: language,
            child: widget.itemBuilder != null
                ? widget.itemBuilder!(language)
                : _buildDefaultMenuItem(language)))
        .toList();

    return DropdownButtonHideUnderline(
      child: DropdownButton<Language>(
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _selectedLanguage = value!;
            widget.onValuePicked!(value);
          });
        },
        items: items,
        value: _selectedLanguage,
      ),
    );
  }

  Widget _buildDefaultMenuItem(Language language) {
    return Text("${language.name} (${language.isoCode})");
  }
}
