import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/AdminView.dart';
import 'package:frontend/views/ConfirmReport.dart';
import 'package:frontend/views/CreateComment.dart';
import 'package:frontend/views/CreatePost.dart';
import 'package:frontend/views/ReportPage.dart';
import 'package:frontend/views/ViewImage.dart';
import 'package:frontend/views/ViewProfile.dart';
import 'package:html_unescape/html_unescape.dart';

class Comments extends StatefulWidget {
  final String postID;

  const Comments({Key? key, required this.postID}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  //for the main post
  var post = {};
  bool init = true;
  bool fetched = false;
  final Map<String, String> currentlyTranslated = {};

  //for the comments of the post
  var commentData = [];


  Future load() async {
    var dataCall = await PostHelper.getPostByID(widget.postID);
    var comCall = await PostHelper.getComments(widget.postID);
    if (mounted) {
      setState(() {
        fetched = true;
        post = dataCall;
        commentData = comCall;
        init = false;
      });
    }
  }

  void firstload() {
    load();
  }

  void deletePost(String postID) {
    loadDelete(postID);
  }

    Widget _buildList() {
    return RefreshIndicator(
      onRefresh: () => loadUpdate(),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          print("Current Index:$index");
          print("Current Length:${commentData.length}");
          if (commentData.isEmpty && index == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return _buildComment(index);
        },
      ),
    );
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

    Future<void> loadUpdate() async {
    var dataCall = await PostHelper.getComments(widget.postID);
    if (mounted) {
      setState(() {
        commentData.clear();
        commentData.addAll(dataCall);
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
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

  void navigateToViewProfile(String postID, String posterID) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: ViewProfile(posterID: posterID),
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

    void navigateToAdminView(String postID) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: AdminView(postID: postID),
          );
        },
      ),
    );
  }

    void navigateToReportPost(String postID) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: ReportPage(postID: postID),
          );
        },
      ),
    );
  }

    void navigateToConfirmPost() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const Scaffold(
            body: ConfirmReport(),
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
    if (post.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    String posterName = post["username"];
    String postContent = post["content"];
    String postID = post["_id"];
    String posterID = post['userID'];
    String reportNumber = post['reports'];
    late int likes = post['likes'];
    bool posterIsAdmin = false;
    bool userIsAdmin = false;
    String attachmentURL = 'Empty';
    if (post['attachedImage'] != 'Empty') {
      attachmentURL = post['attachedImage']['url'];
    }
    //These booleans below may come in handy when we are making admin views
    bool deleted = false;
    bool removed = false;
    if (AuthHelper.userInfoCache['admin'] == 'True') {
      userIsAdmin = true;
    }
    bool isEdited = false;
    var liked = post['liked'];
    var unreviewedReport = post['unreviewedReport'];
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

    String commentNumber = '0';

    SizedBox postBodyContainer = SizedBox(
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
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                    )),
                if (isEdited)
                  const TextSpan(
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
                SizedBox(
                  height: 15,
                  width: 15,
                  child: SvgPicture.asset(
                    'assets/icon-x.svg',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('Close Menu'),
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
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: SvgPicture.asset(
                      'assets/PostUI/icon-editpost.svg',
                      color: const Color(0xff0094FF),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
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
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: SvgPicture.asset(
                      'assets/PostUI/icon-trash.svg',
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
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
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: SvgPicture.asset(
                      'assets/PostUI/icon-flag.svg',
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
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
      color: const Color(0xffffffff),
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
        height: calculatedHeight + 100,
        child: Stack(
          children: [
            Positioned(
              left: 15,
              child: GestureDetector(
                onTap: () {
                  navigateToViewProfile(postID, posterID);
                },
                child: Container(
                  width: 50, // Set your desired width
                  height: 50, // Set your desired height
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: "$imageURL?tr=w-50,h-50,fo-auto",
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 80,
              top: 14,
              child: GestureDetector(
                onTap: () {
                  navigateToViewProfile(postID, posterID);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: posterName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                          )),
                      if (posterIsAdmin)
                        TextSpan(
                          text: ' [${Localize("Admin")}]',
                          style: const TextStyle(
                            color: Color.fromRGBO(4, 57, 39, 100),
                          ),
                        ),
                    ],
                  ),
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
                            "[${Localize('Deleted By User')}]",
                            style: const TextStyle(color: Colors.red),
                          )
                        : (removed)
                            ? Text(
                                "[${Localize('Post Removed')}]",
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            : const SizedBox()
                    : const SizedBox()),
            Positioned(
              left: 340,
              top: 12.5,
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
                color: const Color(0x5f000000),
              ),
            ),
            Positioned(
              top: 65,
              left: 55,
              child: postBodyContainer,
            ),
            Positioned(
              bottom: 80,
              right: 10,
              child: (attachmentURL != 'Empty')
                  ? GestureDetector(
                      onTap: () {
                        navigateToViewImage([attachmentURL]);
                      },
                      child: Container(
                        height: 340,
                        width: 340,
                        color: Colors.black,
                        child: CachedNetworkImage(
                          imageUrl: "$attachmentURL?tr=w-340,h-340,fo-auto",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            Positioned(
              bottom: 20,
              left: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var response = await PostHelper.likePost(postID);
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
                        child: (liked)
                            ? Stack(
                                children: [
                                  Positioned(
                                    left: 1,
                                    child: SvgPicture.asset(
                                      'assets/PostUI/icon-heartFilled.svg',
                                      color: Colors.red,
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/PostUI/icon-heart.svg',
                                    color: Colors.black,
                                    height: 20,
                                    width: 20,
                                  )
                                ],
                              )
                            : SvgPicture.asset(
                                'assets/PostUI/icon-heart.svg',
                                color: Colors.black,
                                height: 20,
                                width: 20,
                              ),
                      ),
                      Text(formattedLikes, style: const TextStyle(fontSize: 11))
                    ],
                  ),
                  const SizedBox(width: 5),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                            Navigator.push(
                                context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateComment(isEditing: false, postID: postID)));
                        },
                        child: SvgPicture.asset(
                          "assets/PostUI/icon-comment.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Text(commentNumber, style: const TextStyle(fontSize: 11))
                    ],
                  ),
                  (userIsAdmin) ? const SizedBox(width: 5) : const SizedBox(),
                  (userIsAdmin)
                      ? Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  navigateToAdminView(postID);
                                },
                                child: SvgPicture.asset(
                                  "assets/PostUI/icon-flag.svg",
                                  height: 20,
                                  width: 20,
                                  color: (unreviewedReport)
                                      ? Colors.deepOrange
                                      : Colors.black,
                                )),
                            Text(reportNumber,
                                style: const TextStyle(fontSize: 11))
                          ],
                        )
                      : const SizedBox(),
                  (userIsAdmin)
                      ? (deleted)
                          ? const SizedBox()
                          : const SizedBox(width: 5)
                      : const SizedBox(),
                  (userIsAdmin)
                      ? (deleted)
                          ? const SizedBox()
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
                      : const SizedBox(),
                ],
              ),
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
                      if (currentlyTranslated.containsKey(postID)) {
                        currentlyTranslated.remove(postID);
                      } else {
                        currentlyTranslated[postID] = 'True';
                      }
                    });
                  }
                },
                child: Text(
                  (currentlyTranslated.containsKey(postID))
                      ? Localize("Original Text")
                      : Localize("Translate"),
                  style: const TextStyle(
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

Widget _buildComment(int index) {
    String imageURL = commentData[index]["profilePicture"]['url'];
    String attachmentURL = 'Empty';
    if (commentData[index]['attachedImage'] != 'Empty') {
      attachmentURL = commentData[index]['attachedImage']['url'];
    }
    String posterName = commentData[index]["username"];
    String postContent = commentData[index]["content"];
    String postID = commentData[index]["_id"];
    String posterID = commentData[index]['userID'];
    String reportNumber = commentData[index]['reports'];
    late int likes = commentData[index]['likes'];
    bool posterIsAdmin = false;
    bool userIsAdmin = false;
    //These booleans below may come in handy when we are making admin views
    bool deleted = false;
    bool removed = false;
    if (AuthHelper.userInfoCache['admin'] == 'True') {
      userIsAdmin = true;
    }
    bool isEdited = false;
    var liked = commentData[index]['liked'];
    var reportedByUser = commentData[index]['reportedByUser'];
    var unreviewedReport = commentData[index]['unreviewedReport'];
    if (commentData[index]['edited'] == 'True') {
      isEdited = true;
    }
    if (commentData[index]['posterIsAdmin'] == 'True') {
      posterIsAdmin = true;
    }
    if (commentData[index]['deleted'] == 'True') {
      deleted = true;
    }
    if (commentData[index]['removed'] == 'True') {
      removed = true;
    }
    var unescape = HtmlUnescape();

    String formattedLikes = formatLargeNumber(likes);
    postContent = postContent.replaceAll('\n', ' ');
    bool postTooLong = false;
    if (postContent.length > 200) {
      postTooLong = true;
      postContent = postContent.substring(0, 200);
      postContent += "...";
    }

    String commentNumber = '0';

    SizedBox postBodyContainer = SizedBox(
      width: 280,
      child: Builder(
        builder: (BuildContext context) {
          return RichText(
            softWrap: true,
            text: TextSpan(
              children: [
                TextSpan(
                    text: (currentlyTranslated.containsKey(postID))
                        ? unescape.convert(
                            PostHelper.cachedTranslations[postContent]!)
                        : postContent,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                    )),
                if (isEdited)
                  TextSpan(
                    text: Localize('(Edited)'),
                    style: const TextStyle(
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
          navigateToEditPost(commentData[index]["content"], postID);
        } else if (result == 'deletePost') {
          deletePost(postID);
        } else if (result == 'reportPost') {
          if (reportedByUser) {
            navigateToConfirmPost();
          } else {
            navigateToReportPost(postID);
          }
        }
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<String>> menuItems = [];

        menuItems.add(
          PopupMenuItem<String>(
            value: 'closeMenu',
            child: Row(
              children: [
                SizedBox(
                  height: 15,
                  width: 15,
                  child: SvgPicture.asset(
                    'assets/icon-x.svg',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(Localize('Close Menu')),
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
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: SvgPicture.asset(
                      'assets/PostUI/icon-editpost.svg',
                      color: const Color(0xff0094FF),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    Localize('Edit Post'),
                    style: const TextStyle(
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
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: SvgPicture.asset(
                      'assets/PostUI/icon-trash.svg',
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    Localize('Delete Post'),
                    style: const TextStyle(
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
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: SvgPicture.asset(
                      'assets/PostUI/icon-flag.svg',
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    Localize('Report Post'),
                    style: const TextStyle(
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
      color: const Color(0xffffffff),
      child: Stack(
        children: [
          const Positioned(
            child: SizedBox(
              width: 40,
              height: 25,
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: SvgPicture.asset(
              "assets/PostUI/icon-3dots.svg",
              width: 20,
              height: 5,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );

    double calculatedHeight = (postContent.length / 25 * 14) + 50;
    if (postTooLong) calculatedHeight += 35;
    if (attachmentURL != 'Empty') {
      calculatedHeight += 410;
    }

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: calculatedHeight + 100,
        child: Stack(
          children: [
            Positioned(
              left: 15,
              child: GestureDetector(
                onTap: () {
                  navigateToViewProfile(postID, posterID);
                },
                child: Container(
                  width: 50, // Set your desired width
                  height: 50, // Set your desired height
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: "$imageURL?tr=w-50,h-50,fo-auto",
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 80,
              top: 14,
              child: GestureDetector(
                onTap: () {
                  navigateToViewProfile(postID, posterID);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: posterName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                          )),
                      if (posterIsAdmin)
                        TextSpan(
                          text: ' [${Localize("Admin")}]',
                          style: const TextStyle(
                            color: Color.fromRGBO(4, 57, 39, 100),
                          ),
                        ),
                    ],
                  ),
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
                            "[${Localize('Deleted By User')}]",
                            style: const TextStyle(color: Colors.red),
                          )
                        : (removed)
                            ? Text(
                                "[${Localize('Post Removed')}]",
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            : const SizedBox()
                    : const SizedBox()),
            Positioned(
              left: 340,
              top: 12.5,
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
                color: const Color(0x5f000000),
              ),
            ),
            Positioned(
              top: 65,
              left: 55,
              child: postBodyContainer,
            ),
            Positioned(
              bottom: 80,
              right: 10,
              child: (attachmentURL != 'Empty')
                  ? GestureDetector(
                      onTap: () {
                        navigateToViewImage([attachmentURL]);
                      },
                      child: Container(
                        height: 340,
                        width: 340,
                        color: Colors.black,
                        child: CachedNetworkImage(
                          imageUrl: "$attachmentURL?tr=w-340,h-340,fo-auto",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            Positioned(
              bottom: 20,
              left: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var response = await PostHelper.likePost(postID);
                          setState(() {
                            commentData[index]['liked'] = !liked;

                            liked = !liked;

                            if (liked) {
                              commentData[index]['likes']++;
                            } else {
                              commentData[index]['likes']--;
                            }
                          });
                        },
                        child: (liked)
                            ? Stack(
                                children: [
                                  Positioned(
                                    left: 1,
                                    child: SvgPicture.asset(
                                      'assets/PostUI/icon-heartFilled.svg',
                                      color: Colors.red,
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/PostUI/icon-heart.svg',
                                    color: Colors.black,
                                    height: 20,
                                    width: 20,
                                  )
                                ],
                              )
                            : SvgPicture.asset(
                                'assets/PostUI/icon-heart.svg',
                                color: Colors.black,
                                height: 20,
                                width: 20,
                              ),
                      ),
                      Text(formattedLikes, style: const TextStyle(fontSize: 11))
                    ],
                  ),
                  const SizedBox(width: 5),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Comments(postID: postID)));
                          /*ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Comment Tapped")));*/
                        },
                        child: SvgPicture.asset(
                          "assets/PostUI/icon-comment.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Text(commentNumber, style: const TextStyle(fontSize: 11))
                    ],
                  ),
                  (userIsAdmin) ? const SizedBox(width: 5) : const SizedBox(),
                  (userIsAdmin)
                      ? Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  navigateToAdminView(postID);
                                },
                                child: SvgPicture.asset(
                                  "assets/PostUI/icon-flag.svg",
                                  height: 20,
                                  width: 20,
                                  color: (unreviewedReport)
                                      ? Colors.deepOrange
                                      : Colors.black,
                                )),
                            Text(reportNumber,
                                style: const TextStyle(fontSize: 11))
                          ],
                        )
                      : const SizedBox(),
                  (userIsAdmin)
                      ? (deleted)
                          ? const SizedBox()
                          : const SizedBox(width: 5)
                      : const SizedBox(),
                  (userIsAdmin)
                      ? (deleted)
                          ? const SizedBox()
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
                      : const SizedBox(),
                ],
              ),
            ),
            Positioned(
              bottom: 33,
              left: 280,
              child: GestureDetector(
                onTap: () async {
                  await translatePost(postContent);
                  if (commentData[index]['translations'] == '') {
                    await PostHelper.storeTranslation(
                        PostHelper.cachedTranslations[postContent]!,
                        commentData[index]['_id']);
                  }
                  if (mounted) {
                    setState(() {
                      if (currentlyTranslated.containsKey(postID)) {
                        currentlyTranslated.remove(postID);
                      } else {
                        currentlyTranslated[postID] = 'True';
                      }
                    });
                  }
                },
                child: Text(
                  (currentlyTranslated.containsKey(postID))
                      ? Localize("Original Text")
                      : Localize("Translate"),
                  style: const TextStyle(
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
                              content: Text(Localize(
                                  "Expanded Post (should go to same place as comments)"))));
                        },
                        child: SizedBox(
                          width: 250,
                          child: Text(
                            Localize(
                                "Post too tall to view on home page. Please click here to expand post."),
                            style: const TextStyle(
                              color: Color(0x55000000),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
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
            const SizedBox(height: 5), 
            Expanded(child: _buildPost()),
            Expanded(
              child: (commentData.isNotEmpty)
                ? _buildList()
                : Center(
                    child: Text(Localize("No Comments Found"))
                  ),
            )
          ]
        )
    );
  }
}
