import 'package:flutter/material.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';

class AdminView extends StatefulWidget {
  String postID;
  AdminView({super.key, required this.postID});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  var post;
  Map postData = {};
  bool firstLoad = true;

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

  void firstload() {
    reload();
    firstLoad = false;
  }

  void reload() async {
    var dataCall = await PostHelper.getPostByID(widget.postID);
    if (mounted) {
      setState(() {
        post = dataCall;
        print(post);
        firstLoad = false;
        //postData = jsonDecode(dataCall) as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (firstLoad) {
      firstload();
    }

    if (postData == {}) {
      return Scaffold(
        body: Center(child: Text("Loading Post...")),
      );
    }

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
              "Moderate Post",
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
        body: Center(
          child: Text('this is broken and unfinished, go away'),
        ));
  }
}
