import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/selectorHelper.dart';
import 'package:frontend/views/ViewImage.dart';

class ViewProfile extends StatefulWidget {
  String posterID;
  String postID;
  ViewProfile({super.key, required this.posterID, required this.postID});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var poster;
  var post;
  Map postData = {};
  bool needsReload = true;
  Map<String, bool> currentlyTranslated = {};
  List contentHistory = [];
  int contentIndex = 0;

  void navigateToPrimaryScreens() {
    Navigator.of(context).pop();
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
  void initState() {
    super.initState();
    firstload();
  }

  void firstload() async {
    reload();
  }

  void reload() async {
    var userData = await PostHelper.getUserByID(widget.posterID);
    var postData = await PostHelper.getPostByID(widget.postID);
    if (mounted) {
      setState(() {
        poster = userData;
        post = postData;
        needsReload = false;
      });
    }
  }

  Future<void> banDialog(BuildContext context, String userID) async {
    TextEditingController textController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Localize('Would you like to ban this user?')),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: Localize('Ban Reasoning')),
            maxLines: null,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.of(context).pop();
              },
              child: Text(Localize('Cancel')),
            ),
            TextButton(
              onPressed: () async {
                await AuthHelper.banUser(AuthHelper.userInfoCache['_id'],
                    userID, textController.text);
                Navigator.of(context).pop();
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(Localize("User has been Banned.")),
                  ));
                  needsReload = true;
                });
              },
              child: Text(Localize('Confirm')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (needsReload) {
      firstload();
    }

    if (poster == null) {
      return Scaffold(
        backgroundColor: Color(0xffece7d5),
        body: Center(child: Text(Localize("Loading Profile..."))),
      );
    }

    String userID = post['userID'];
    String posterName = poster["username"];
    String posterEmail = poster["email"];
    String pfpURL = poster["profilePicture.url"];
    String posterNationality = Localize(poster["nationality"]);
    String posterLanguage = AuthHelper.languageNames[poster["language"]];
    posterLanguage = Localize(posterLanguage);
    String englishNationality = poster['nationality'];
    String? emojiCheck = SelectorHelper.countryEmojiMap[englishNationality];
    String? adminCheck = poster['admin'];
    bool? bannedCheck = post['posterIsBanned'];
    bool posterIsAdmin = false;
    bool posterBanned = false;
    bool userIsAdmin = false;
    String emoji = '';

    if (AuthHelper.userInfoCache['admin'] == 'True') {
      userIsAdmin = true;
    }
    if (adminCheck == 'True') {
      posterIsAdmin = true;
    }
    if (bannedCheck != null) {
      if (bannedCheck) {
        posterBanned = bannedCheck;
      }
    }

    if (emojiCheck != null) {
      emoji = '$emojiCheck ';
    }

    return Scaffold(
      backgroundColor: const Color(0xffece7d5),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: GestureDetector(
            child: const Icon(
              Icons.close,
              color: Colors.black,
              size: 30,
            ),
            onTap: () => navigateToPrimaryScreens(),
          ),
          title: Text(
            Localize("User Profile"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              height: 1.0, // Set the desired height of the line
              color: const Color(0x5f000000),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  navigateToViewImage([pfpURL]);
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: "$pfpURL?tr=w-150,h-150,fo-auto",
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
            Align(
              alignment: Alignment.center,
              child: ListTile(
                title: Text(
                  posterName,
                  textAlign: TextAlign.center,
                  textScaleFactor: 2,
                ),
              ),
            ),
            (posterBanned)
                ? Align(
                    child: Text(Localize("[USER HAS BEEN BANNED]"),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  )
                : const SizedBox(),
            Align(
              alignment: Alignment.centerLeft,
              child: ListTile(
                leading: const Icon(Icons.flag),
                title: Text(
                  Localize('Nationality'),
                  textAlign: TextAlign.left,
                ),
                subtitle: Text(emoji + posterNationality),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ListTile(
                leading: const Icon(Icons.chat_rounded),
                title: Text(
                  Localize('Language'),
                  textAlign: TextAlign.left,
                ),
                subtitle: Text(posterLanguage),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.mail),
              title: Text(Localize('Email Address')),
              subtitle: Text(posterEmail),
            ),
            (userIsAdmin)
                ? Align(
                    child: GestureDetector(
                      onTap: () async {
                        if (posterIsAdmin) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                Localize("You cannot ban an admin account!")),
                          ));
                        } else {
                          print(post['posterIsBanned']);
                          await banDialog(context, userID);
                        }
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.gavel_outlined,
                          color: Colors.redAccent,
                        ),
                        title: Text(
                          Localize('Ban User'),
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
