import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/selectorHelper.dart';
import 'package:frontend/views/CoreTemplate.dart';
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
  bool firstLoad = true;
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
        firstLoad = false;
      });
    }
  }
  
  Future<void> banDialog(BuildContext context, String userID) async {
    TextEditingController textController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Would you like to ban this poster?'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Ban Reasoning'),
            maxLines: null,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await AuthHelper.banUser(AuthHelper.userInfoCache['_id'],
                    userID, textController.text);
                Navigator.of(context).pop();
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("User has been Banned."),
                  ));
                  firstLoad = true;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (poster == null) {
      return const Scaffold(
        backgroundColor: Color(0xffece7d5),
        body: Center(child: Text("Loading Profile...")),
      );
    }

    String userID = post['userID'];
    String posterName = poster["username"];
    String posterEmail = poster["email"];
    String pfpURL = poster["profilePicture.url"];
    String posterNationality = Localize(poster["nationality"]);
    String posterLanguage = AuthHelper.languageNames[poster["language"]];
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
    if (adminCheck == 'true') {
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
    String? localizedLanguage = SelectorHelper.reverseLangMap[poster['language']];
    if (localizedLanguage != null) {
      posterLanguage = localizedLanguage;
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
          title: const Text(
            "User Profile",
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
            (posterBanned)?
            const Align(
              child: Text("[USER HAS BEEN BANNED]",
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
            (userIsAdmin) ?
            Align(
              child: GestureDetector(
                onTap: () async {
                  if (posterIsAdmin) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("You cannot ban an admin account!"),
                    ));
                  } else {
                    print(post['posterIsBanned']);
                    await banDialog(context, userID);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black, width: 1.0),
                    color: Color.fromARGB(255, 233, 54, 54),
                  ),
                  child: const Text(
                    'Ban User',
                    style: TextStyle(color: Colors.black),
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
