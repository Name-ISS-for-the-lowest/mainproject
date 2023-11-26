import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  }

  void reload() async {
    var dataCall = await PostHelper.getPostByID(widget.postID);
    if (mounted) {
      setState(() {
        post = jsonDecode(dataCall);
        print('POST PRINT HERE');
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

    if (post == null) {
      return Scaffold(
        backgroundColor: const Color(0xffece7d5),
        body: Center(child: Text("Loading Post...")),
      );
    }

    String postContent = post['content'];
    String userID = post['userID'];
    String reports = post['reports'];
    String posterName = post['username'];
    String posterEmail = post['email'];
    int reportNumber = int.parse(reports);
    String adminCheck = post['posterIsAdmin'];
    String pfpURL = post['profilePicture']['url'];
    bool posterIsAdmin = false;
    if (adminCheck == 'True') {
      posterIsAdmin = true;
    }
    var reportReasons = post['reportReasons'];
    int hateSpeech = reportReasons['hateSpeech'];
    int targetedHarassment = reportReasons['targetedHarassment'];
    int illegalContent = reportReasons['illegalContent'];
    int inappropriateContent = reportReasons['inappropriateContent'];
    int otherReason = reportReasons['otherReason'];

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
      body: Container(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Posted By",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 200, // Set your desired width
                height: 200, // Set your desired height
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: "$pfpURL?tr=w-200,h-200,fo-auto",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                "Screen Name: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                posterName,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Email Address: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                posterEmail,
                style: TextStyle(fontSize: 18),
              ),
              Divider(),
              Text(
                "Image Attached",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
