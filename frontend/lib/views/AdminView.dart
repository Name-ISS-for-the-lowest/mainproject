import 'package:flutter/material.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:frontend/views/ViewImage.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
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

  Future<void> banDialog(BuildContext context, String userID) async {
    TextEditingController textController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Would you like to ban this user?'),
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
    if (firstLoad) {
      firstload();
    }

    if (post == null) {
      return const Scaffold(
        backgroundColor: Color(0xffece7d5),
        body: Center(child: Text("Loading Post...")),
      );
    }

    String postContent = post['content'];
    String userID = post['userID'];
    String reports = post['reports'];
    String posterName = post['username'];
    String posterEmail = post['email'];
    String? adminCheck = post['posterIsAdmin'];
    bool? bannedCheck = post['posterIsBanned'];
    String pfpURL = post['profilePicture']['url'];
    bool posterIsAdmin = false;
    bool userBanned = false;
    if (adminCheck == 'True') {
      posterIsAdmin = true;
    }
    if (bannedCheck != null) {
      if (bannedCheck) {
        userBanned = bannedCheck;
      }
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
      body: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Posted By",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  navigateToViewImage([pfpURL]);
                },
                child: Container(
                  width: 200, // Set your desired width
                  height: 200, // Set your desired height
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: "$pfpURL?tr=w-200,h-200,fo-auto",
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const Text(
                "Screen Name: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                posterName,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Email Address: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                posterEmail,
                style: const TextStyle(fontSize: 18),
              ),
              (userBanned)
                  ? const Text("[USER HAS BEEN BANNED]",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red))
                  : const SizedBox(),
              const Divider(),
              const Text(
                "Image Attached",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              (attachmentURL == 'Empty')
                  ? const Text(
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
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
              const Divider(),
              const Text(
                "Post Content",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (currentlyTranslated.containsKey(currentlyViewedContent))
                      ? PostHelper.cachedTranslations[currentlyViewedContent]!
                      : currentlyViewedContent,
                  style: const TextStyle(fontSize: 18),
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
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black, width: 1.0),
                    color: Colors.white,
                  ),
                  child: Text(
                      (currentlyTranslated.containsKey(currentlyViewedContent))
                          ? 'Original Text'
                          : 'Translate',
                      style: const TextStyle(
                        color: Color(0xff0094FF),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              (contentHistory.length > 1)
                  ? const Text("Navigate Edit History",
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
                        const Spacer(),
                        (contentIndex - 1 >= 0)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    contentIndex -= 1;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.black, width: 1.0),
                                    color: Colors.white,
                                  ),
                                  child: const Text('Older Version'),
                                ),
                              )
                            : const SizedBox(),
                        const Spacer(),
                        (contentIndex + 1 < contentHistory.length)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    contentIndex += 1;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.black, width: 1.0),
                                    color: Colors.white,
                                  ),
                                  child: const Text(
                                    'Newer Version',
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const Spacer(),
                      ],
                    )
                  : const Text("Post Has No Edit History",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(),
              const Text(
                "Reports Submitted",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "Total Reports Gathered: $reports",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      Text("Hate Speech: $hateSpeech"),
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
                      Text("Targeted Harassment: $targetedHarassment"),
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
                      Text("Inappropriate Content: $inappropriateContent"),
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
                      Text("Illegal Content: $illegalContent"),
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
                      Text("Other Reasons: $otherReason"),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              const Text(
                "Take Action",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      var response = await PostHelper.toggleRemoval(
                          widget.postID, 'Approve');
                      navigateToPrimaryScreens();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 16, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: Colors.white,
                      ),
                      child: const Text(
                        'Approve Post',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      var response = await PostHelper.toggleRemoval(
                          widget.postID, 'Remove');
                      navigateToPrimaryScreens();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 16, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: Colors.white,
                      ),
                      child: const Text(
                        'Remove Post',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  if (posterIsAdmin) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("You cannot ban an admin account!"),
                    ));
                  } else {
                    await banDialog(context, userID);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black, width: 1.0),
                    color: Colors.white,
                  ),
                  child: const Text(
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
