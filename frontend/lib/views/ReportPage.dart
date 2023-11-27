import 'package:flutter/material.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:frontend/views/ConfirmReport.dart';

class ReportPage extends StatefulWidget {
  String postID;
  ReportPage({super.key, required this.postID});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String reason = 'harassment';
  final Map<String, bool> reasonsSelected = {
    'hateSpeech': false,
    'illegalContent': false,
    'targetedHarassment': false,
    'inappropriateContent': false,
    'otherReason': false
  };

  final Map<String, String> textToArg = {
    'Hate Speech': 'hateSpeech',
    'Illegal Content': 'illegalContent',
    'Targeted Harassment': 'targetedHarassment',
    'Inappropriate Content': 'inappropriateContent',
    'Other Reason': 'otherReason'
  };

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

  void navigateToConfirm() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: ConfirmReport(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            "Report Post",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(20.0),
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Are you sure you want to report this post?",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "We at International Student Station take reports very seriously, and highly encourage our users to report posts when they feel as if our rules are broken.",
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Please select the rule(s) you felt were violated in the post, and hit submit if you would like to file a report. Alternatively, hit the close button on the top left of your screen to cancel the report.",
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ])),
          Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      reasonsSelected['hateSpeech'] =
                          !reasonsSelected['hateSpeech']!;
                    });
                  },
                  child: buildMenu('Hate Speech'),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      reasonsSelected['illegalContent'] =
                          !reasonsSelected['illegalContent']!;
                    });
                  },
                  child: buildMenu('Illegal Content'),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      reasonsSelected['targetedHarassment'] =
                          !reasonsSelected['targetedHarassment']!;
                    });
                  },
                  child: buildMenu('Targeted Harassment'),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      reasonsSelected['inappropriateContent'] =
                          !reasonsSelected['inappropriateContent']!;
                    });
                  },
                  child: buildMenu('Inappropriate Content'),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      reasonsSelected['otherReason'] =
                          !reasonsSelected['otherReason']!;
                    });
                  },
                  child: buildMenu('Other Reason'),
                ),
              ])),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () async {
              //String reasonValue = await reason;
              var response =
                  await PostHelper.reportPost(widget.postID, reasonsSelected);
              navigateToConfirm();
              print(widget.postID);
            },
            child: const Text(
              "Submit",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff007EF1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenu(String option) {
    String argOption = textToArg[option]!;
    bool? selected = reasonsSelected[argOption];
    Color unselectedOption = Color(0xffF2F0F4);
    Color selectedOption = Color(0xffC9C9C9);
    Color unselected = Color(0xaa000000);
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.black, width: 1.0),
        color: selected! ? selectedOption : unselectedOption,
      ),
      child: Text(
        option,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: selected ? Colors.black : unselected,
        ),
      ),
    );
  }
}
