import 'package:flutter/material.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/views/CoreTemplate.dart';

class ReportPage extends StatefulWidget {
  String postID;
  ReportPage({super.key, required this.postID});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String selectedOption = '';

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
          )
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child:  const Column(
              children: [
                Text(
                  "Are you sure you want to report this post?",
                  style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,),
                  ),
                SizedBox(height: 10.0),
                Text(
                  "We at International Student Station take reports very seriously, and highly encourage our users to report posts when they feel as if our rules are broken.",
                ),
                SizedBox(height: 10.0),
                Text(
                  "Please select the rule(s) you felt were violated in the post, and hit submit if you would like to file a report. Alternatively, hit the back arrow on the top left of your screen to cancel the report.",
                ),
              ]
            )
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 110.0),
            child:  Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Hate Speech';
                    });
                  },
                  child: buildMenu('Hate Speech'),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Illegal Content';
                    });
                  },
                  child: buildMenu('Illegal Content'),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Targeted Harassment';
                    });
                  },
                  child: buildMenu('Targeted Harassment'),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Inappropriate Content';
                    });
                  },
                  child: buildMenu('Inappropriate Content'),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Other Reason';
                    });
                  },
                  child: buildMenu('Other Reason'),
                ),
              ]
            )
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () async {
              var response = await PostHelper.reportPost(widget.postID);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'])));
                    print(widget.postID);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
  Widget buildMenu(String option) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            option,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: selectedOption == option ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
