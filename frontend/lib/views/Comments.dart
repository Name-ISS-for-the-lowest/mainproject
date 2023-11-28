import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:frontend/views/CreatePost.dart';

class Comments extends StatefulWidget {
  final String postID;

  Comments({Key? key, required this.postID}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  var post = {};
  bool init = true;
  final Map<String, String> currentlyTranslated = {};
  Map postData = {};
  bool fetched = false;

  Future load() async {
    var dataCall = await PostHelper.getPostByID(widget.postID);
    print("printing data call...");
    print(dataCall);
    if (mounted) {
      setState(() {
        fetched = true;
        post = jsonDecode(dataCall);
        print("printing...");
        print(post);
        init = false;
        //postData = jsonDecode(dataCall) as Map<String, dynamic>;
      });
    }
  }

  void firstload() {
    load();
  }

  void deletePost(String postID) {
    loadDelete(postID);
  }

  Future<void> loadDelete(String postID) async {
    await PostHelper.deletePost(postID);
    var dataCall = await PostHelper.getPostByID(postID);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadRemovalToggle(String postID) async {
    await PostHelper.toggleRemoval(postID);
    var dataCall = await PostHelper.getPostByID(postID);
    if (mounted) {
      setState(() {});
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

  Future<void> translatePost(String originalText) async {
    if (PostHelper.cachedTranslations.containsKey(originalText)) {
      return;
    } else if (post['translations'] != '') {
      if (mounted) {
        setState(() {
          PostHelper.cachedTranslations[originalText] = post['translations'];
        });
        return;
      }
    } else {
      var translationCall = await PostHelper.getTranslation(originalText);
      if (mounted) {
        setState(() {
          String returnedTranslation = translationCall['result'];
          PostHelper.cachedTranslations[originalText] = returnedTranslation;
        });
      }
    }
  }

  Widget _buildPost() {
    if (!fetched) {
      return const Text("Loading");
    }
    String imageURL = post["profilePicture"]["url"];
    String posterName = post["username"];
    String postContent = post["content"];
    String postID = post["_id"];
    String posterID = post['userID'];
    late int likes = post['likes'];
    bool posterIsAdmin = false;
    bool userIsAdmin = false;
    //These booleans below may come in handy when we are making admin views
    bool deleted = false;
    bool removed = false;
    if (AuthHelper.userInfoCache['admin'] == 'True') {
      userIsAdmin = true;
    }
    bool isEdited = false;
    var liked = post['liked'];
    if (post['edited'] == 'True') {
      isEdited = true;
    }
    if (post['posterIsAdmin'] == 'True') {
      posterIsAdmin = true;
    }
    if (post['deleted'] == 'True') {
      deleted = true;
    }
    if (post['removed'] == 'True') {
      removed = true;
    }

    String formattedLikes = formatLargeNumber(likes);
    postContent = postContent.replaceAll('\n', ' ');

    Container postBodyContainer = Container(
      width: 280,
      child: Builder(
        builder: (BuildContext context) {
          return RichText(
            softWrap: true,
            text: TextSpan(
              children: [
                TextSpan(
                    text: (currentlyTranslated.containsKey(postContent))
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
          navigateToEditPost(post["content"], postID);
        } else if (result == 'deletePost') {
          deletePost(postID);
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

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: calculatedHeight,
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
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 80,
              top: 14,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: posterName,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Inter',
                        )),
                    if (posterIsAdmin)
                      TextSpan(
                        text: ' [Admin]',
                        style: TextStyle(
                          color: Color.fromRGBO(4, 57, 39, 100),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 80,
                top: 40,
                //I'm sorry for my sins
                child: (userIsAdmin)
                    ? (deleted)
                        ? Text(
                            "[Deleted By User]",
                            style: TextStyle(color: Colors.red),
                          )
                        : (removed)
                            ? Text(
                                "[Post Removed]",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            : SizedBox()
                    : SizedBox()),
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
                    var response = await PostHelper.likePost(postID);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'])));
                    setState(() {
                      post['liked'] = !liked;

                      liked = !liked;

                      if (liked) {
                        post['likes']++;
                      } else {
                        post['likes']--;
                      }
                    });
                  },
                  child: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.red : Colors.black,
                    size: 20,
                  )),
            ),
            Positioned(
              bottom: 15,
              left: 45,
              child: Text(formattedLikes, style: TextStyle(fontSize: 11)),
            ),
            Positioned(
              bottom: 33,
              left: 120,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Flag Tapped")));
                },
                child: (userIsAdmin)
                    ? SvgPicture.asset(
                        "assets/PostUI/icon-flag.svg",
                        height: 20,
                        width: 20,
                        color: Colors.deepOrange,
                      )
                    : SizedBox(),
              ),
            ),
            Positioned(
              bottom: 33,
              left: 155,
              child: (userIsAdmin)
                  ? (deleted)
                      ? SizedBox()
                      : GestureDetector(
                          onTap: () async {
                            await loadRemovalToggle(postID);
                          },
                          child: (removed)
                              ? SvgPicture.asset(
                                  "assets/PostUI/icon-approve.svg",
                                  height: 20,
                                  width: 20,
                                  color: Colors.green,
                                )
                              : SvgPicture.asset(
                                  "assets/PostUI/icon-remove.svg",
                                  height: 18,
                                  width: 18,
                                  color: Colors.red,
                                ))
                  : SizedBox(),
            ),
            Positioned(
              bottom: 33,
              left: 280,
              child: GestureDetector(
                onTap: () async {
                  await translatePost(postContent);
                  if (post['translations'] == '') {
                    await PostHelper.storeTranslation(
                        PostHelper.cachedTranslations[postContent]!,
                        post['_id']);
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.postID);
    if (init) {
      firstload();
      init = false;
    }
    bool userIsAdmin = false;
    if (AuthHelper.userInfoCache['admin'] == 'True') {
      userIsAdmin = true;
    }
    return Scaffold(
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
          onTap: () => Navigator.pop(context),
        ),
        title: const Text(
          "Comments",
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
            height: 1.0,
            color: const Color(0x5f000000),
          ),
        ),
      ),
      backgroundColor: const Color(0xffece7d5),
      body: Column(
        children: [
          SizedBox(height: 5),
          Expanded(
            child:
                _buildPost()
          ),
          const Spacer(),
        ]
      ),
    );
  }
}
