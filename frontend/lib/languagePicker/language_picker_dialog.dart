import 'package:frontend/languagePicker/languages.dart';
import 'package:frontend/languagePicker/utils/typedefs.dart';

import 'package:frontend/languagePicker/utils/my_alert_dialog.dart';
import 'package:flutter/material.dart';

///Provides a customizable [Dialog] which displays all languages
/// with optional search feature

class LanguagePickerDialog extends StatefulWidget {
  /// Callback that is called with selected Language
  final ValueChanged<Language>? onValuePicked;

  /// The (optional) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// Padding around the title.
  ///
  /// If there is no title, no padding will be provided. Otherwise, this padding
  /// is used.
  ///
  /// This property defaults to providing 12 pixels on the top,
  /// 16 pixels on bottom of the title. If the [content] is not null, then no bottom padding is
  /// provided (but see [contentPadding]). If it _is_ null, then an extra 20
  /// pixels of bottom padding is added to separate the [title] from the
  /// [actions].
  final EdgeInsetsGeometry? titlePadding;

  /// Padding around the content.

  final EdgeInsetsGeometry contentPadding;

  /// The semantic label of the dialog used by accessibility frameworks to
  /// announce screen transitions when the dialog is opened and closed.
  ///
  /// If this label is not provided, a semantic label will be infered from the
  /// [title] if it is not null.  If there is no title, the label will be taken
  /// from [MaterialLocalizations.alertDialogLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.isRouteName], for a description of how this
  ///    value is used.
  final String? semanticLabel;

  ///Callback that is called with selected item of type Language which returns a
  ///Widget to build list view item inside dialog
  final ItemBuilder? itemBuilder;

  /// The (optional) horizontal separator used between title, content and
  /// actions.
  ///
  /// If this divider is not provided a [Divider] is used with [height]
  /// property is set to 0.0
  final Widget divider;

  /// The [divider] is not displayed if set to false. Default is set to true.
  final bool isDividerEnabled;

  /// Determines if search [TextField] is shown or not
  /// Defaults to false
  final bool isSearchable;

  /// The optional [decoration] of search [TextField]
  final InputDecoration? searchInputDecoration;

  ///The optional [cursorColor] of search [TextField]
  final Color? searchCursorColor;

  ///The search empty view is displayed if nothing returns from search result
  final Widget? searchEmptyView;

  /// List of languages available in this picker.
  final List<Language>? languages;

  const LanguagePickerDialog({
    Key? key,
    this.onValuePicked,
    this.title,
    this.titlePadding,
    this.contentPadding = const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
    this.semanticLabel,
    this.itemBuilder,
    this.isDividerEnabled = false,
    this.divider = const Divider(
      height: 0.0,
    ),
    this.isSearchable = false,
    this.searchInputDecoration,
    this.searchCursorColor,
    this.searchEmptyView,
    this.languages,
  }) : super(key: key);

  @override
  SingleChoiceDialogState createState() {
    return SingleChoiceDialogState();
  }
}

class SingleChoiceDialogState extends State<LanguagePickerDialog> {
  late List<Language> _allLanguages;
  late List<Language> _filteredLanguages;

  @override
  void initState() {
    _allLanguages = widget.languages ?? Languages.defaultLanguages;
    _filteredLanguages = _allLanguages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyAlertDialog(
      title: _buildHeader(),
      contentPadding: widget.contentPadding,
      semanticLabel: widget.semanticLabel,
      content: _buildContent(context),
      isDividerEnabled: widget.isDividerEnabled,
      divider: widget.divider,
    );
  }

  _buildContent(BuildContext context) {
    return _filteredLanguages.isNotEmpty
        ? ListView(
            shrinkWrap: true,
            children: _filteredLanguages
                .map((item) => SimpleDialogOption(
                      child: widget.itemBuilder != null
                          ? widget.itemBuilder!(item)
                          : Text(item.name),
                      onPressed: () {
                        widget.onValuePicked!(item);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          )
        : widget.searchEmptyView ??
            const Center(
              child: Text('No language found.'),
            );
  }

  _buildHeader() {
    return widget.isSearchable
        ? Column(
            children: <Widget>[
              _buildTitle(),
              _buildSearchField(),
            ],
          )
        : _buildTitle();
  }

  _buildTitle() {
    return widget.titlePadding != null
        ? Padding(
            padding: widget.titlePadding!,
            child: widget.title,
          )
        : widget.title;
  }

  _buildSearchField() {
    return TextField(
      cursorColor: widget.searchCursorColor,
      decoration:
          widget.searchInputDecoration ?? const InputDecoration(hintText: 'Search'),
      onChanged: (String value) {
        setState(() {
          _filteredLanguages = _allLanguages
              .where((Language language) =>
                  language.name.toLowerCase().startsWith(value.toLowerCase()) ||
                  language.isoCode
                      .toLowerCase()
                      .startsWith(value.toLowerCase()))
              .toList();
        });
      },
    );
  }
}
