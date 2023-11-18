import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/postHelper.dart';

class ForumHome extends StatefulWidget {
  const ForumHome({super.key});

  @override
  State<ForumHome> createState() => _ForumHomeState();
}

class _ForumHomeState extends State<ForumHome> {
  var postData = [];
  int postsFetched = 0;
  int postsPerFetch = 25;
  bool init = false;
  Map<String, String> currentlyTranslated = Map();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (isAtBottom()) {
      reload();
    }
  }

  bool isAtBottom() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      return true;
    }
    return false;
  }

  void firstload() {
    loadData();
  }

  Future<void> loadData() async {
    var dataCall = await PostHelper.getPosts(0, postsPerFetch);
    //Add a sleep here to simulate loading
    // await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      setState(() {
        postData = dataCall;
        init = true;
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        postsFetched += convertedFetch;
      });
    }
  }

  String formatLargeNumber(int number) {
    if (number < 1000) {
      return number.toString();
    }
    double num = number / 1000.0;
    String suffix = 'K';

    if (num >= 1000) {
      num /= 1000.0;
      suffix = 'M';
    }
    return '${num.toStringAsFixed(1)}$suffix';
  }

  void reload() {
    addData();
  }

  Future<void> addData() async {
    //Add a sleep here to simulate loading
    // await Future.delayed(const Duration(seconds: 5));
    var dataCall =
        await PostHelper.getPosts(postsFetched, postsFetched + postsPerFetch);
    if (mounted) {
      setState(() {
        print("dataCall: $dataCall");
        print(dataCall[0]['profilePicture']['url']);
        postData.addAll(dataCall);
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        postsFetched += convertedFetch;
      });
    }
  }

  Future<void> translatePost(String originalText, int index) async {
    if (PostHelper.cachedTranslations.containsKey(originalText)) {
      return;
    } else if (postData[index]['translations'] != '') {
      if (mounted) {
        setState(() {
          PostHelper.cachedTranslations[originalText] =
              postData[index]['translations'];
        });
        return;
      }
    } else {
      var translationCall = await PostHelper.getTranslation(originalText);
      print(translationCall);
      if (mounted) {
        setState(() {
          String returnedTranslation = translationCall['result'];
          PostHelper.cachedTranslations[originalText] = returnedTranslation;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      firstload();
    }

    return Scaffold(
      backgroundColor: Color(0xffece7d5),
      body: ListView.builder(
        itemCount: postData.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          String imageURL = postData[index]["profilePicture"]['url'];
          String posterName = postData[index]["username"];
          String postContent = postData[index]["content"];
          String postID = postData[index]["_id"];
          late int likes = postData[index]['likes'];
          String formattedLikes = formatLargeNumber(likes);
          postContent = postContent.replaceAll('\n', ' ');
          bool postTooLong = false;
          if (postContent.length > 200) {
            postTooLong = true;
            postContent = postContent.substring(0, 200);
            postContent += "...";
          }

          Container postBodyContainer = Container(
            width: 280,
            child: Builder(
              builder: (BuildContext context) {
                return Text(
                  (currentlyTranslated.containsKey(postContent))
                      ? currentlyTranslated[postContent]!
                      : postContent,
                  softWrap: true,
                );
              },
            ),
          );

          double calculatedHeight = (postContent.length / 25 * 14) + 50;
          if (postTooLong) calculatedHeight += 35;

          return Container(
            height: calculatedHeight + 100,
            child: Stack(
              children: [
                Positioned(
                  left: 15,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "$imageURL?tr=w-50,h-50,fo-auto",
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 80,
                  top: 14,
                  child: Text(
                    posterName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 350,
                  top: 22.5,
                  child: Container(
                    child: SizedBox(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("3 Dots Tapped")));
                        },
                        child: SvgPicture.asset(
                          "assets/PostUI/icon-3dots.svg",
                          width: 20,
                          height: 5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 40,
                  top: 65,
                  child: Container(
                    height: calculatedHeight,
                    width: 1,
                    color: Color(0x5f000000),
                  ),
                ),
                Positioned(
                  top: 65,
                  left: 55,
                  child: postBodyContainer,
                ),
                Positioned(
                  bottom: 33,
                  left: 50,
                  child: GestureDetector(
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Heart Tapped")));
                      var response = await PostHelper.likePost(postID);
                      likes = postData[index]['likes'];
                      print(postID);
                    },
                    child: SvgPicture.asset(
                      "assets/PostUI/icon-heart.svg",
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 45,
                  child: Text(likes.toString(), style: TextStyle(fontSize: 11)),
                ),
                Positioned(
                  bottom: 33,
                  left: 85,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Comment Tapped")));
                    },
                    child: SvgPicture.asset(
                      "assets/PostUI/icon-comment.svg",
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 33,
                  left: 280,
                  child: GestureDetector(
                    onTap: () async {
                      await translatePost(postContent, index);
                      if (postData[index]['translations'] == '') {
                        await PostHelper.storeTranslation(
                            PostHelper.cachedTranslations[postContent]!,
                            postData[index]['_id']);
                      }
                      if (mounted) {
                        setState(() {
                          if (currentlyTranslated.containsKey(postContent)) {
                            currentlyTranslated.remove(postContent);
                          } else {
                            currentlyTranslated[postContent] =
                                PostHelper.cachedTranslations[postContent]!;
                          }
                        });
                      }
                    },
                    child: Text(
                      (currentlyTranslated.containsKey(postContent))
                          ? "Original Text"
                          : "Translate",
                      style: TextStyle(
                        color: Color(0xff0094FF),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 55,
                  child: postTooLong
                      ? Container(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Expanded Post (should go to same place as comments)")));
                            },
                            child: Text(
                              "Post too tall to view on home page.\nPlease click here to expand post.",
                              style: TextStyle(
                                color: Color(0x55000000),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
