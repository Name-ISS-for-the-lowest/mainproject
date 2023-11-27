import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/views/CoreTemplate.dart';

class ViewProfile extends StatefulWidget {
  String posterID;
  ViewProfile({super.key, required this.posterID});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var user;
  Map postData = {};
  bool firstLoad = true;
  Map<String, bool> currentlyTranslated = {};
  List contentHistory = [];
  int contentIndex = 0;

  void navigateToPrimaryScreens() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const Scaffold(
            body: CoreTemplate(),
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
    if (mounted) {
      setState(() {
        user = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xffece7d5),
        body: Center(child: Text("Loading Profile...")),
      );
    }

    String posterName = user["username"];
    String posterEmail = user["email"];
    String pfpURL = user["profilePicture.url"];
    String posterNationality = user["nationality"];
    String posterLanguage = user["language"];

    return Scaffold(
      backgroundColor: const Color(0xffece7d5),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
              ],
            ),
            Stack(
              children: <Widget>[
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text(
                        posterName,
                        textAlign: TextAlign.center,
                        textScaleFactor: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                      subtitle: Text(posterNationality),
                    ),
                  ),
                ),
              ],
            ),
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
                      subtitle: Text(posterLanguage),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: ListTile(
                leading: const Icon(Icons.mail),
                title: Text(Localize('Email Address')),
                subtitle: Text(posterEmail),
              ),
            ),
          ],
        )
      );
  }
}