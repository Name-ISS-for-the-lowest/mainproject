import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/CoreTemplate.dart';

class ReportPage extends StatefulWidget {
  String postID;
  ReportPage({super.key, required this.postID});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  void navigateToPrimaryScreens() {
    Navigator.of(context).push(
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffece7d5),
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
          title: Text(
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
      body: Align(
        alignment: Alignment.center,
        child: Container(
          height: 800,
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Are you sure you want to report this post?"),
              Text(
                  "We at International Student Station take reports very seriously, and highly encourage our users to report posts when they feel as if our rules are broken."),
              Text(
                  "Please select the rule(s) you felt were violated in the post, and hit submit if you would like to file a report. Alternatively, hit the back arrow on the top left of your screen to cancel the report."),
            ],
          ),
        ),
      ),
    );
  }
}
