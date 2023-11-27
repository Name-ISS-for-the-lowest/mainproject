import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/selectorHelper.dart';
// import 'package:language_picker/language_picker.dart';
// import 'package:language_picker/languages.dart';
import '../languagePicker/languages.dart';
import '../languagePicker/language_picker.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:frontend/home.dart';
import 'package:frontend/views/ViewImage.dart';

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

  void navigateToViewImage(List<String> inputs) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: ViewImage(imageUrls: inputs),
          );
        },
      ),
    );
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
    Language selectedDialogLanguage = Languages.english;

//COUNTRY SELECTOR
    void countryselect() {
      showCountryPicker(
          context: context,
          favorite: <String>['US', 'CN', 'MX', 'IN'],
          //exclude: <String>['FR'],
          countryListTheme: const CountryListThemeData(
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
          const SizedBox(
            width: 0.0,
          ),
          Text(language.name),
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
                dialogBackgroundColor: const Color(0xfff7ebe1),
                dialogTheme: DialogTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: LanguagePickerDialog(
                  languages: supportedLanguages,
                  titlePadding: const EdgeInsets.all(8.0),
                  //searchCursorColor: Colors.pinkAccent,
                  searchInputDecoration:
                      InputDecoration(hintText: Localize('Search')),
                  isSearchable: true,
                  title: Text(Localize('Select your language')),
                  onValuePicked: (Language language) async {
                    print(AuthHelper.userInfoCache['language']);
                    AuthHelper.userInfoCache['language'] = language.isoCode;
                    selectedDialogLanguage = language;
                    PostHelper.cachedTranslations = {};
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
        onPressed: () async {
          AuthHelper.logout();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Home()),
              (route) => false);
        },
      );

      AlertDialog alert = AlertDialog(
        backgroundColor: const Color(0xfff7ebe1),
        //backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(Localize("ACCOUNT DEACTIVATION")),
        content: Text(Localize(
            "THIS ACTION CANNOT BE UNDONE FROM THE APP. ARE YOU SURE YOU WANT TO CONTINUE?")),
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

    void ListPicker(BuildContext context, [bool languagesPicked = false]) {
      List listChoice = SelectorHelper.countryList;

      if (languagesPicked) {
        listChoice = SelectorHelper.langNames;
      }

      Map<String, String> trueItems = {};
      List items = [];
      if (languagesPicked) {
        listChoice.forEach((element) {
          items.add(element);
          trueItems[element] = SelectorHelper.langMap[element]!;
        });
      } else {
        listChoice.forEach((element) {
          String localizedElem = Localize(element);
          items.add(localizedElem);
          trueItems[localizedElem] = element;
        });
      }

      List filteredItems = List.from(items);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (query) {
                          setState(() {
                            filteredItems = items
                                .where((item) =>
                                    item
                                        .toLowerCase()
                                        .contains(query.toLowerCase()) ||
                                    trueItems[item]!
                                        .toLowerCase()
                                        .contains(query.toLowerCase()))
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Enter your search query',
                        ),
                      ),
                    ),
                  ],
                ),
                content: Container(
                  width: double.maxFinite,
                  height: 500,
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          if (languagesPicked) {
                            AuthHelper.userInfoCache['language'] =
                                trueItems[filteredItems[index]];
                          } else {
                            AuthHelper.userInfoCache['nationality'] =
                                trueItems[filteredItems[index]];
                          }
                          await updateUser();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          //dont ask me why but this color argument is necessary
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 280,
                                    child: Text(
                                      (languagesPicked)
                                          ? filteredItems[index]
                                          : SelectorHelper.countryEmojiMap[
                                                  trueItems[
                                                      filteredItems[index]]]! +
                                              '  ' +
                                              filteredItems[index],
                                      style: TextStyle(fontSize: 20),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      );

                      return ListTile(
                        title: Text(filteredItems[index]),
                        onTap: () async {
                          AuthHelper.userInfoCache['nationality'] =
                              trueItems[index];
                          await updateUser();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    //LOGOUT BUTTON
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
          AuthHelper.logout();

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Home()),
              (route) => false);
        },
      );

      AlertDialog alert = AlertDialog(
        backgroundColor: const Color(0xfff7ebe1),
        shape: const RoundedRectangleBorder(
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
            title: Text(Localize('Your Screen Name')),
            backgroundColor: const Color(0xfff7ebe1),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: TextField(
              autofocus: true,
              decoration:
                  InputDecoration(hintText: Localize('Enter your name')),
              controller: controller,
            ),
            actions: [
              TextButton(
                child: Text(Localize('Cancel')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(Localize('Submit')),
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
      Navigator.of(context).pop();
      var profilePicture = await AuthHelper.setProfilePicture(imageTemporary);
      AuthHelper.userInfoCache['profilePicture.url'] = profilePicture['url'];
      AuthHelper.userInfoCache['profilePicture.fileId'] =
          profilePicture['fileId'];
      await updateUser();
      //setState(() => this.image = imageTemporary);
    }

    Future pickCamera() async {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      Navigator.of(context).pop();
      var profilePicture = await AuthHelper.setProfilePicture(imageTemporary);
      print(AuthHelper.userInfoCache['profilePicture.url']);
      print(AuthHelper.userInfoCache['profilePicture.fileId']);
      AuthHelper.userInfoCache['profilePicture.url'] = profilePicture['url'];
      AuthHelper.userInfoCache['profilePicture.fileId'] =
          profilePicture['fileId'];
      await updateUser();
      //setState(() => this.image = imageTemporary);
    }

    void openCameraDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: const Color(0xfff7ebe1)),
            child: SimpleDialog(
              title: Text(Localize("Image Source")),
              children: <Widget>[
                SimpleDialogOption(
                  child: Text(Localize('Select from Gallery')),
                  onPressed: () => pickImage(),
                ),
                SimpleDialogOption(
                  child: Text(Localize('Open Camera')),
                  onPressed: () => pickCamera(),
                ),
                SimpleDialogOption(
                  child: Text(Localize('Close')),
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
        backgroundColor: const Color(0xffece7d5),
        // body: Center(child: Text("Profile Page")),

        body: ListView(
          children: [
            Stack(
              children: <Widget>[
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        navigateToViewImage([imageURL]);
                      },
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
                ),
                Positioned.fill(
                  top: 10,
                  left: 140,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
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
                      icon: const Icon(Icons.edit_note),
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
                      leading: const Icon(Icons.flag),
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
                      icon: const Icon(Icons.edit_note),
                      onPressed: () {
                        ListPicker(context);
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
                      leading: const Icon(Icons.chat_rounded),
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
                      icon: const Icon(Icons.edit_note),
                      onPressed: () {
                        ListPicker(context, true);
                      },
                    ),
                  ),
                ),
              ],
            ),

            //EMAIL ADDRESS
            Container(
              child: ListTile(
                leading: const Icon(Icons.mail),
                title: Text(Localize('Email Address')),
                subtitle: Text(emailAddress),
              ),
            ),

            //LOG OUT
            Container(
              child: ListTile(
                leading: const Icon(Icons.logout),

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
                leading: const Icon(Icons.delete),
                iconColor: Colors.redAccent,
                title: Text(Localize('Deactivate Account')),
                subtitle: Text(
                    Localize('This action cannot be restored from the app.')),
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
