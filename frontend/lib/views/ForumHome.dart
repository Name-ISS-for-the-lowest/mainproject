import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/views/CreatePost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ForumHome extends StatefulWidget {
  const ForumHome({super.key});

  @override
  State<ForumHome> createState() => _ForumHomeState();
}

class _ForumHomeState extends State<ForumHome> {
  var postData = [];
  int postsFetched = 0;
  int postsPerFetch = 25;
  String currentSearch = "";
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
      if (currentSearch == "") {
        reload();
      } else {
        loadSearch();
      }
    }
  }

  bool isAtBottom() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      return true;
    }
    return false;
  }

  void navigateToEditPost(String postContent, String postID) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: CreatePost(
                isEditing: true, originalText: postContent, postID: postID),
          );
        },
      ),
    );
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

  Future<void> searchPosts(String search) async {
    if (search == "") {
      var dataCall = await PostHelper.getPosts(0, postsPerFetch);
      if (mounted) {
        setState(() {
          postData = dataCall;
          num fetchedLength = dataCall.length;
          int convertedFetch = fetchedLength.toInt();
          postsFetched = convertedFetch;
        });
      }
    } else {
      var dataCall = await PostHelper.searchPosts(
          0, postsPerFetch, search, AuthHelper.userInfoCache["_id"]);
      if (mounted) {
        setState(() {
          postData = dataCall;
          num fetchedLength = dataCall.length;
          int convertedFetch = fetchedLength.toInt();
          postsFetched = convertedFetch;
        });
      }
    }
  }

  Future<void> addSearchedPosts(String search) async {
    var dataCall = await PostHelper.searchPosts(postsFetched,
        postsFetched + postsPerFetch, search, AuthHelper.userInfoCache["_id"]);
    if (mounted) {
      setState(() {
        postData.addAll(dataCall);
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

  void loadSearch() {
    addSearchedPosts(currentSearch);
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
      print("translationCall: ");
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
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                child: SvgPicture.asset(
                  "assets/searchBar.svg",
                  height: 80,
                ),
              ),
              Container(
                  height: 80,
                  width: 360,
                  margin: EdgeInsets.only(top: 10, left: 10),
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: (currentSearch == "")
                          ? 'Type Search Here'
                          : currentSearch,
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (text) {
                      currentSearch = text;
                    },
                    onSubmitted: (value) async {
                      if (value == "") {
                        currentSearch = "";
                        await loadData();
                      } else {
                        await searchPosts(currentSearch);
                      }
                    },
                  )),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: postData.length,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) {
                String imageURL = postData[index]["profilePicture"]['url'];
                String posterName = postData[index]["username"];
                String postContent = postData[index]["content"];
                String postID = postData[index]["_id"];
                String posterID = postData[index]['user_id'];
                late int likes = postData[index]['likes'];
                bool isEdited = false;
                if (postData[index]['edited'] == 'True') {
                  isEdited = true;
                }
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
                      return RichText(
                        softWrap: true,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: (currentlyTranslated
                                        .containsKey(postContent))
                                    ? currentlyTranslated[postContent]!
                                    : postContent,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                )),
                            if (isEdited)
                              TextSpan(
                                text: ' (Edited)',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );

                PopupMenuButton<String> threeDotMenu = PopupMenuButton<String>(
                  onSelected: (String result) {
                    // Handle the selected option
                    if (result == 'closeMenu') {
                      // Closes menu and does absolutely nothing
                    } else if (result == 'editPost') {
                      navigateToEditPost(postData[index]["content"], postID);
                    } else if (result == 'deletePost') {
                      // Handle option 2
                    } else if (result == 'reportPost') {
                      // Handle option 2
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuEntry<String>> menuItems = [];

                    menuItems.add(
                      PopupMenuItem<String>(
                        value: 'closeMenu',
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              child: SvgPicture.asset(
                                'assets/icon-x.svg',
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Close Menu'),
                          ],
                        ),
                      ),
                    );

                    if (posterID == AuthHelper.userInfoCache['_id']) {
                      menuItems.add(
                        PopupMenuItem<String>(
                          value: 'editPost',
                          child: Row(
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                child: SvgPicture.asset(
                                  'assets/PostUI/icon-editpost.svg',
                                  color: Color(0xff0094FF),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Edit Post',
                                style: TextStyle(
                                  color: Color(0xff0094FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      menuItems.add(
                        PopupMenuItem<String>(
                          value: 'deletePost',
                          child: Row(
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                child: SvgPicture.asset(
                                  'assets/PostUI/icon-trash.svg',
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Delete Post',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      menuItems.add(
                        PopupMenuItem<String>(
                          value: 'reportPost',
                          child: Row(
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                child: SvgPicture.asset(
                                  'assets/PostUI/icon-flag.svg',
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Report Post',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return menuItems;
                  },
                  color: Color(0xffffffff),
                  child: SvgPicture.asset(
                    "assets/PostUI/icon-3dots.svg",
                    width: 20,
                    height: 5,
                    color: Colors.black,
                  ),
                );

                double calculatedHeight = (postContent.length / 25 * 14) + 50;
                if (postTooLong) calculatedHeight += 35;

                return SizedBox(
                  height: calculatedHeight + 100,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 15,
                        child: Container(
                          width: 50, // Set your desired width
                          height: 50, // Set your desired height
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: "$imageURL?tr=w-50,h-50,fo-auto",
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.fill,
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
                          child: threeDotMenu,
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
                        child: Text(likes.toString(),
                            style: TextStyle(fontSize: 11)),
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
                                if (currentlyTranslated
                                    .containsKey(postContent)) {
                                  currentlyTranslated.remove(postContent);
                                } else {
                                  currentlyTranslated[postContent] = PostHelper
                                      .cachedTranslations[postContent]!;
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
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
          )
        ],
      ),
    );
  }
}
