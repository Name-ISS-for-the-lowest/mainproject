import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:frontend/views/ViewImage.dart';
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
  Map<String, bool> currentlyTranslated = {};
  List contentHistory = [];
  int contentIndex = 0;

  void navigateToPrimaryScreens() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: CoreTemplate(),
          );
        },
      ),
    );
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

  void firstload() {
    reload();
  }

  void reload() async {
    var dataCall = await PostHelper.getPostByID(widget.postID);
    if (mounted) {
      setState(() {
        post = dataCall;
        firstLoad = false;
        contentHistory = post['contentHistory'];
        contentHistory.add(post['content']);
        contentIndex = contentHistory.length - 1;
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
    String adminCheck = post['posterIsAdmin'];
    String pfpURL = post['profilePicture']['url'];
    bool posterIsAdmin = false;
    if (adminCheck == 'True') {
      posterIsAdmin = true;
    }
    String currentlyViewedContent = contentHistory[contentIndex];

    var reportReasons = post['reportReasons'];
    int reportNumber = int.parse(reports);
    int hateSpeech = reportReasons['hateSpeech'];
    int targetedHarassment = reportReasons['targetedHarassment'];
    int illegalContent = reportReasons['illegalContent'];
    int inappropriateContent = reportReasons['inappropriateContent'];
    int otherReason = reportReasons['otherReason'];

    if (reportNumber == 0) {
      reportNumber = 1;
    }

    double hateSpeechProportion = hateSpeech / reportNumber;
    double targetedHarassmentProportion = targetedHarassment / reportNumber;
    double illegalContentProportion = illegalContent / reportNumber;
    double inappropriateContentProportion = inappropriateContent / reportNumber;
    double otherReasonProportion = otherReason / reportNumber;

    String attachmentURL = 'Empty';
    if (post['attachedImage'] != 'Empty') {
      attachmentURL = post['attachedImage']['url'];
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
              (attachmentURL == 'Empty')
                  ? Text(
                      "No Image Attached",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : GestureDetector(
                      onTap: () {
                        navigateToViewImage([attachmentURL]);
                      },
                      child: CachedNetworkImage(
                        imageUrl: "$attachmentURL?tr=w-400,h-auto",
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
              Divider(),
              Text(
                "Post Content",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (currentlyTranslated.containsKey(currentlyViewedContent))
                      ? PostHelper.cachedTranslations[currentlyViewedContent]!
                      : currentlyViewedContent,
                  style: TextStyle(fontSize: 18),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  var translationCall;
                  if (PostHelper.cachedTranslations
                          .containsKey(currentlyViewedContent) ==
                      false) {
                    translationCall =
                        await PostHelper.getTranslation(currentlyViewedContent);
                  }
                  if (mounted) {
                    setState(() {
                      if (translationCall != null) {
                        String returnedTranslation = translationCall['result'];
                        PostHelper.cachedTranslations[currentlyViewedContent] =
                            returnedTranslation;
                      }
                      if (currentlyTranslated
                          .containsKey(currentlyViewedContent)) {
                        currentlyTranslated.remove(currentlyViewedContent);
                      } else {
                        currentlyTranslated[currentlyViewedContent] = true;
                      }
                    });
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black, width: 1.0),
                    color: Colors.white,
                  ),
                  child: Text(
                      (currentlyTranslated.containsKey(currentlyViewedContent))
                          ? 'Original Text'
                          : 'Translate',
                      style: TextStyle(
                        color: Color(0xff0094FF),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              (contentHistory.length > 1)
                  ? Text("Navigate Edit History",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                  : const SizedBox(),
              (contentHistory.length > 1)
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(),
              (contentHistory.length > 1)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(),
                        (contentIndex - 1 >= 0)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    contentIndex -= 1;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.black, width: 1.0),
                                    color: Colors.white,
                                  ),
                                  child: Text('Older Version'),
                                ),
                              )
                            : const SizedBox(),
                        Spacer(),
                        (contentIndex + 1 < contentHistory.length)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    contentIndex += 1;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.black, width: 1.0),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    'Newer Version',
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Spacer(),
                      ],
                    )
                  : Text("Post Has No Edit History",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Divider(),
              Text(
                "Reports Submitted",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "Total Reports Gathered: " + reports,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.black, width: 1)),
                        height: 20,
                        width: (hateSpeechProportion * 140) + 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Hate Speech: " + hateSpeech.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            border: Border.all(color: Colors.black, width: 1)),
                        height: 20,
                        width: (targetedHarassmentProportion * 140) + 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Targeted Harassment: " +
                          targetedHarassment.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            border: Border.all(color: Colors.black, width: 1)),
                        height: 20,
                        width: (inappropriateContentProportion * 140) + 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Inappropriate Content: " +
                          inappropriateContent.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.black, width: 1)),
                        height: 20,
                        width: (illegalContentProportion * 140) + 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Illegal Content: " + illegalContent.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(color: Colors.black, width: 1)),
                        height: 20,
                        width: (otherReasonProportion * 140) + 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Other Reasons: " + otherReason.toString()),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(),
              Text(
                "Take Action",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      var response = await PostHelper.toggleRemoval(
                          widget.postID, 'Approve');
                      navigateToPrimaryScreens();
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 8, left: 16, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: Colors.white,
                      ),
                      child: Text(
                        'Approve Post',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      var response = await PostHelper.toggleRemoval(
                          widget.postID, 'Remove');
                      navigateToPrimaryScreens();
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 8, left: 16, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: Colors.white,
                      ),
                      child: Text(
                        'Remove Post',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black, width: 1.0),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Ban User',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
