import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/selectorHelper.dart';
import '../languagePicker/languages.dart';
import 'package:image_picker/image_picker.dart';
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
    String englishNationality = AuthHelper.userInfoCache['nationality'];
    String nationality = Localize(englishNationality);
    String? emojiCheck = SelectorHelper.countryEmojiMap[englishNationality];
    String emoji = '';
    if (emojiCheck != null) {
      emoji = '$emojiCheck ';
    }
    String? localizedLanguage =
        SelectorHelper.reverseLangMap[AuthHelper.userInfoCache['language']];
    String language =
        AuthHelper.languageNames[AuthHelper.userInfoCache['language']];
    if (localizedLanguage != null) {
      language = localizedLanguage;
    }
    String emailAddress = AuthHelper.userInfoCache['email'];
    Language selectedDialogLanguage = Languages.english;

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
        for (var element in listChoice) {
          items.add(element);
          trueItems[element] = SelectorHelper.langMap[element]!;
        }
      } else {
        for (var element in listChoice) {
          String localizedElem = Localize(element);
          items.add(localizedElem);
          trueItems[localizedElem] = element;
        }
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
                        decoration: const InputDecoration(
                          labelText: 'Search',
                          hintText: 'Enter your search query',
                        ),
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
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
                            PostHelper.cachedTranslations = {};
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
                                  SizedBox(
                                    width: 280,
                                    child: Text(
                                      (languagesPicked)
                                          ? filteredItems[index]
                                          : '${SelectorHelper.countryEmojiMap[trueItems[filteredItems[index]]]!}  ' +
                                              filteredItems[index],
                                      style: const TextStyle(fontSize: 20),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
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
          await AuthHelper.logout();

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
                    child: Container(
                      width: 150, // Set your desired width
                      height: 150, // Set your desired height
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: "$imageURL?tr=w-150,h-150,fo-auto",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                      subtitle: Text(emoji + nationality),
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
