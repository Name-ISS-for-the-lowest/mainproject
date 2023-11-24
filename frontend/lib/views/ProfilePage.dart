import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/postHelper.dart';
// import 'package:language_picker/language_picker.dart';
// import 'package:language_picker/languages.dart';
import '../languagePicker/languages.dart';
import '../languagePicker/language_picker.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:restart_app/restart_app.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> updateUser() async {
    var response = await AuthHelper.updateUser();
    if (mounted) {
      setState(() {});
    }
  }

  late TextEditingController controller;
  String name = '';

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void submit() async {
    Navigator.of(context).pop(controller.text);
    await updateUser();
  }

  @override
  Widget build(BuildContext context) {
    //USER VARIABLES

    String imageURL = AuthHelper.userInfoCache['profilePicture.url'];
    String displayName = AuthHelper.userInfoCache['username'];
    String nationality = Localize(AuthHelper.userInfoCache['nationality']);
    String language =
        AuthHelper.languageNames[AuthHelper.userInfoCache['language']];
    String emailAddress = AuthHelper.userInfoCache['email'];
    Language _selectedDialogLanguage = Languages.english;

//COUNTRY SELECTOR
    void countryselect() {
      showCountryPicker(
          context: context,
          favorite: <String>['US', 'CN', 'MX', 'IN'],
          //exclude: <String>['FR'],
          countryListTheme: CountryListThemeData(
            backgroundColor: Color(0xffece7d5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          onSelect: (Country country) async {
            AuthHelper.userInfoCache['nationality'] = country.name;
            await updateUser();
          });
    }

    Widget _buildDialogItem(Language language) {
      return Row(
        children: <Widget>[
          SizedBox(
            width: 0.0,
          ),
          Text("${language.name}"),
          //Text("${language.name}"),
          //Text("${language.name} (${language.isoCode})"),
        ],
      );
    }

    //Language WHITELIST
    final supportedLanguages = [
      Language.fromIsoCode('af'),
      Language.fromIsoCode('sq'),
      Language.fromIsoCode('am'),
      Language.fromIsoCode('ar'),
      Language.fromIsoCode('hy'),
      Language.fromIsoCode('as'),
      Language.fromIsoCode('ay'),
      Language.fromIsoCode('az'),
      Language.fromIsoCode('bm'),
      Language.fromIsoCode('eu'),
      Language.fromIsoCode('be'),
      Language.fromIsoCode('bn'),
      Language.fromIsoCode('bho'),
      Language.fromIsoCode('bs'),
      Language.fromIsoCode('bg'),
      Language.fromIsoCode('ca'),
      Language.fromIsoCode('ceb'),
      Language.fromIsoCode('ny'),
      Language.fromIsoCode('zh'),
      Language.fromIsoCode('zh-TW'),
      Language.fromIsoCode('co'),
      Language.fromIsoCode('hr'),
      Language.fromIsoCode('cs'),
      Language.fromIsoCode('da'),
      Language.fromIsoCode('dv'),
      Language.fromIsoCode('doi'),
      Language.fromIsoCode('nl'),
      Language.fromIsoCode('en'),
      Language.fromIsoCode('eo'),
      Language.fromIsoCode('et'),
      Language.fromIsoCode('ee'),
      Language.fromIsoCode('tl'),
      Language.fromIsoCode('fi'),
      Language.fromIsoCode('fr'),
      Language.fromIsoCode('fy'),
      Language.fromIsoCode('gl'),
      Language.fromIsoCode('lg'),
      Language.fromIsoCode('ka'),
      Language.fromIsoCode('de'),
      Language.fromIsoCode('el'),
      Language.fromIsoCode('gn'),
      Language.fromIsoCode('gu'),
      Language.fromIsoCode('ht'),
      Language.fromIsoCode('ha'),
      Language.fromIsoCode('haw'),
      Language.fromIsoCode('iw'),
      Language.fromIsoCode('hi'),
      Language.fromIsoCode('hmn'),
      Language.fromIsoCode('hu'),
      Language.fromIsoCode('is'),
      Language.fromIsoCode('ig'),
      Language.fromIsoCode('ilo'),
      Language.fromIsoCode('id'),
      Language.fromIsoCode('ga'),
      Language.fromIsoCode('it'),
      Language.fromIsoCode('ja'),
      Language.fromIsoCode('jw'),
      Language.fromIsoCode('kn'),
      Language.fromIsoCode('kk'),
      Language.fromIsoCode('km'),
      Language.fromIsoCode('rw'),
      Language.fromIsoCode('gom'),
      Language.fromIsoCode('ko'),
      Language.fromIsoCode('kri'),
      Language.fromIsoCode('ku'),
      Language.fromIsoCode('ckb'),
      Language.fromIsoCode('ky'),
      Language.fromIsoCode('lo'),
      Language.fromIsoCode('la'),
      Language.fromIsoCode('lv'),
      Language.fromIsoCode('ln'),
      Language.fromIsoCode('lt'),
      Language.fromIsoCode('lb'),
      Language.fromIsoCode('mk'),
      Language.fromIsoCode('mai'),
      Language.fromIsoCode('mg'),
      Language.fromIsoCode('ms'),
      Language.fromIsoCode('ml'),
      Language.fromIsoCode('mt'),
      Language.fromIsoCode('mi'),
      Language.fromIsoCode('mr'),
      Language.fromIsoCode('mni-Mtei'),
      Language.fromIsoCode('lus'),
      Language.fromIsoCode('mn'),
      Language.fromIsoCode('my'),
      Language.fromIsoCode('ne'),
      Language.fromIsoCode('nso'),
      Language.fromIsoCode('no'),
      Language.fromIsoCode('or'),
      Language.fromIsoCode('om'),
      Language.fromIsoCode('ps'),
      Language.fromIsoCode('fa'),
      Language.fromIsoCode('pl'),
      Language.fromIsoCode('pt'),
      Language.fromIsoCode('pa'),
      Language.fromIsoCode('qu'),
      Language.fromIsoCode('ro'),
      Language.fromIsoCode('ru'),
      Language.fromIsoCode('sm'),
      Language.fromIsoCode('sa'),
      Language.fromIsoCode('gd'),
      Language.fromIsoCode('sr'),
      Language.fromIsoCode('st'),
      Language.fromIsoCode('sn'),
      Language.fromIsoCode('sd'),
      Language.fromIsoCode('si'),
      Language.fromIsoCode('sk'),
      Language.fromIsoCode('sl'),
      Language.fromIsoCode('so'),
      Language.fromIsoCode('es'),
      Language.fromIsoCode('su'),
      Language.fromIsoCode('sw'),
      Language.fromIsoCode('sv'),
      Language.fromIsoCode('tg'),
      Language.fromIsoCode('ta'),
      Language.fromIsoCode('tt'),
      Language.fromIsoCode('te'),
      Language.fromIsoCode('th'),
      Language.fromIsoCode('ti'),
      Language.fromIsoCode('ts'),
      Language.fromIsoCode('tr'),
      Language.fromIsoCode('tk'),
      Language.fromIsoCode('ak'),
      Language.fromIsoCode('uk'),
      Language.fromIsoCode('ur'),
      Language.fromIsoCode('ug'),
      Language.fromIsoCode('uz'),
      Language.fromIsoCode('vi'),
      Language.fromIsoCode('cy'),
      Language.fromIsoCode('xh'),
      Language.fromIsoCode('yi'),
      Language.fromIsoCode('yo'),
      Language.fromIsoCode('zu'),
      //Language.fromIsoCode('deezNuts'),
    ];

//LANGUAGE SELECTOR
    void _openLanguagePickerDialog() => showDialog(
          context: context,
          builder: (context) => Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.pink,
                dialogBackgroundColor: Color(0xfff7ebe1),
                dialogTheme: DialogTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: LanguagePickerDialog(
                  languages: supportedLanguages,
                  titlePadding: EdgeInsets.all(8.0),
                  //searchCursorColor: Colors.pinkAccent,
                  searchInputDecoration:
                      InputDecoration(hintText: Localize('Search')),
                  isSearchable: true,
                  title: Text(Localize('Select your language')),
                  onValuePicked: (Language language) async {
                    print(AuthHelper.userInfoCache['language']);
                    AuthHelper.userInfoCache['language'] = language.isoCode;
                    _selectedDialogLanguage = language;
                    PostHelper.cachedTranslations = {};

                    // print(_selectedDialogLanguage.name);
                    // print(_selectedDialogLanguage.isoCode);
                    await updateUser();
                  },
                  itemBuilder: _buildDialogItem)),
        );

    //DELETE ACCOUNT BUTTON
    showDeleteAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text(Localize("Cancel")),
        onPressed: () {
          Navigator.pop(context);
          return;
        },
      );
      Widget continueButton = TextButton(
        child: Text(Localize("Continue")),
        onPressed: () {
          Restart.restartApp(webOrigin: '');
        },
      );

      AlertDialog alert = AlertDialog(
        backgroundColor: Color(0xfff7ebe1),
        //backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text("ACCOUNT DELETION"),
        content: Text(
            "THIS ACTION IS IRREVERSABLE. ARE YOU SURE YOU WANT TO CONTINUE?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    //LOGOUT BUTTON
    //DELETE FUNCTION DOES NOT WORK??
    
    // Future<void> deleteCacheDir() async {
    // final cacheDir = await getTemporaryDirectory();

    // if (cacheDir.existsSync()) {
    //   cacheDir.deleteSync(recursive: true);
    //   }
    // }

    // Future<void> deleteAppDir() async {
    // final appDir = await getApplicationSupportDirectory();

    //   if(appDir.existsSync()){
    //     appDir.deleteSync(recursive: true);
    //   }
    // }

    showLogoutAlertDialog(BuildContext context) {
      Widget cancelButton = TextButton(
        child: Text(Localize("Cancel")),
        onPressed: () {
          Navigator.pop(context);
          return;
        },
      );
      Widget continueButton = TextButton(
        child: Text(Localize("Continue")),
        onPressed: () async {
          // deleteAppDir();
          // deleteCacheDir();
          await updateUser();
          Restart.restartApp(webOrigin: '');
        },
      );

      AlertDialog alert = AlertDialog(
        backgroundColor: Color(0xfff7ebe1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(Localize("Log Out")),
        content: Text(
            Localize("You will be returned to the login screen. Continue?")),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    //NAME BUTTON
    Future<String?> openNameDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Your Name'),
        backgroundColor: Color(0xfff7ebe1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: 'Enter your name'),
          controller: controller,
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              submit();
            },
          ),
        ],
      ),
    );

    //CAMERA CODE
    File? image;

    Future pickImage() async {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      //setState(() => this.image = imageTemporary);
    }

    Future pickCamera() async {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      //setState(() => this.image = imageTemporary);
    }

    void openCameraDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: Color(0xfff7ebe1)),
            child: SimpleDialog(
              title: const Text("Image Picker"),
              children: <Widget>[
                SimpleDialogOption(
                  child: const Text('Select from Gallery'),
                  onPressed: () => pickImage(),
                ),
                SimpleDialogOption(
                  child: const Text('Open Camera'),
                  onPressed: () => pickCamera(),
                ),
                SimpleDialogOption(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    //ACTUAL PAGE
    return Scaffold(
        backgroundColor: Color(0xffece7d5),
        // body: Center(child: Text("Profile Page")),

        body: ListView(
          children: [
            Stack(
              children: <Widget>[
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 150, // Set your desired width
                      height: 150, // Set your desired height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: "$imageURL?tr=w-150,h-150,fo-auto",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 10,
                  left: 140,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      iconSize: 50,
                      onPressed: () {
                        openCameraDialog(context);
                      },
                    ),
                  ),
                ),
              ],
            ),

            //USERNAME
            Stack(
              children: <Widget>[
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text(
                        displayName,
                        textAlign: TextAlign.center,
                        textScaleFactor: 2,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  right: 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.edit_note),
                      onPressed: () async {
                        final name = await openNameDialog();
                        if (name == null || name.isEmpty) return;

                        AuthHelper.userInfoCache['username'] = name;
                        await updateUser();
                      },
                    ),
                  ),
                ),
              ],
            ),

            //NATIONALITY
            Stack(
              children: <Widget>[
                Positioned(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(Icons.flag),
                      title: Text(
                        Localize('Nationality'),
                        textAlign: TextAlign.left,
                      ),
                      subtitle: Text(nationality),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.edit_note),
                      onPressed: () {
                        countryselect();
                      },
                    ),
                  ),
                ),
              ],
            ),

            //Language
            Stack(
              children: <Widget>[
                Positioned(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(Icons.chat_rounded),
                      title: Text(
                        Localize('Language'),
                        textAlign: TextAlign.left,
                      ),
                      subtitle: Text(language),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.edit_note),
                      onPressed: () {
                        _openLanguagePickerDialog();
                      },
                    ),
                  ),
                ),
              ],
            ),

            //EMAIL ADDRESS
            Container(
              child: ListTile(
                leading: Icon(Icons.mail),
                title: Text(Localize('Email Address')),
                subtitle: Text(emailAddress),
              ),
            ),

            //LOG OUT
            Container(
              child: ListTile(
                leading: Icon(Icons.logout),

                //LOCALIZE NOT FUNCTIONING AT THE MOMENT
                //title: Text(Localize('Log Out')),
                //subtitle: Text(Localize('Sign out of the current account.')),
                title: Text(Localize('Log Out')),
                subtitle: Text(Localize('Sign out of the current account.')),
                onTap: () async {
                  showLogoutAlertDialog(context);
                },
              ),
            ),

            //DELETE ACCOUNT
            Container(
              child: ListTile(
                leading: Icon(Icons.delete),
                iconColor: Colors.redAccent,
                title: Text(Localize('Delete Account')),
                subtitle: Text(Localize('This action cannot be restored.')),
                textColor: Colors.redAccent,
                onTap: () {
                  showDeleteAlertDialog(context);
                },
              ),
            ),
          ],
        ));
  }
}
