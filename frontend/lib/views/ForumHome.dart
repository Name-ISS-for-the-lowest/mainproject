import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/keywordData.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/views/AdminView.dart';
import 'package:frontend/views/Comments.dart';
import 'package:frontend/views/ConfirmReport.dart';
import 'package:frontend/views/CreatePost.dart';
import 'package:frontend/views/ReportPage.dart';
import 'package:frontend/views/ViewImage.dart';
import 'package:frontend/views/ViewProfile.dart';
import 'package:html_unescape/html_unescape.dart';

class ForumHome extends StatefulWidget {
  const ForumHome({super.key});

  @override
  State<ForumHome> createState() => _ForumHomeState();
}

class _ForumHomeState extends State<ForumHome> {
  final List postData = [];
  final int postsPerFetch = 15;
  Map searchParams = {"search": "", "lastPostFetched": 'None'};
  bool init = false;
  bool searching = false;
  bool firstLoad = true;
  bool adminOptionsToggled = false;
  final Map<String, String> currentlyTranslated = {};
  final Map<String, String> specialSearchArgs = {
    'showReported': 'All',
    'showRemoved': 'None',
    'showDeleted': 'None'
  };

  @override
  void initState() {
    super.initState();
    searchPosts(searchParams["search"]);
  }

  @override
  void dispose() {
    super.dispose();
  }

//searches posts, append to posts searched if search is empty, returns all posts
//Notes, I want to turn this into websockets, because it will speed up search,
//and we can prob add real timeness to it

  Future searchPosts(String search, {bool scrolling = false}) async {
    print("fethching posts $search");
    if (searching) return;
    searching = true;
    if (!scrolling) {
      searchParams["lastPostFetched"] = 'None';
      postData.clear();
    }
    // print("I am fetching posts");
    // print("Posts Fetched:$lastPostFetched");
    // print("Posts Per Fetch:$postsPerFetch");
    if (search == "") {
      try {
        print(searchParams["lastPostFetched"]);
        print(postsPerFetch);
        var dataCall = await PostHelper.getPosts(
            searchParams["lastPostFetched"], postsPerFetch, specialSearchArgs);
        print("Data Call:${dataCall.length}");
        Map dataCallMap = {};
        for (var item in dataCall) {
          dataCallMap[item['_id']] = item;
        }
        var arrayOfCurrentIds = [];
        for (var item in postData) {
          arrayOfCurrentIds.add(item['_id']);
        }
        for (var item in dataCall) {
          //only input items with unique id's
          if (!arrayOfCurrentIds.contains(item['_id'])) {
            postData.add(item);
          }
        }
        if (firstLoad) {
          firstLoad = false;
          setState(() {});
        }
        if (postData.length - 1 >= 0) {
          searchParams["lastPostFetched"] =
              postData[postData.length - 1]['_id'];
        } else {
          searchParams["lastPostFetched"] = 'None';
        }
        searching = false;
        return dataCall;
      } catch (e) {
        print("Error: $e");
        searching = false;
        return [];
      }
    } else {
      try {
        var dataCall = await PostHelper.searchPosts(
            searchParams["lastPostFetched"],
            postsPerFetch,
            search,
            AuthHelper.userInfoCache["_id"],
            specialSearchArgs);
        Map dataCallMap = {};
        for (var item in dataCall) {
          dataCallMap[item['_id']] = item;
        }
        var arrayOfCurrentIds = [];
        for (var item in postData) {
          arrayOfCurrentIds.add(item['_id']);
        }

        for (var item in dataCall) {
          //only input items with unique id's
          if (!arrayOfCurrentIds.contains(item['_id'])) {
            postData.add(item);
          }
        }
        int fetchedLength = dataCall.length;
        if (fetchedLength - 1 >= 0) {
          searchParams["lastPostFetched"] =
              dataCall[dataCall.length - 1]['_id'];
        } else {
          searchParams["lastPostFetched"] = 'None';
        }
        searching = false;
        return dataCall;
      } catch (e) {
        print("Error: $e");
        searching = false;
        return [];
      }
    }
  }

  String formatLargeNumber(int number) {
    String userLang = AuthHelper.userInfoCache['language'];
    if (number < 1000) {
      return number.toString();
    }
    double num = number / 1000.0;

    String suffix = keywordData.thousandSuffix[userLang]!;

    String returnedNumber;

    if (num >= 1000) {
      num /= 1000.0;
      suffix = keywordData.millionSuffix[userLang]!;
    }

    if (keywordData.commaDecimals.contains(userLang)) {
      returnedNumber = num.toStringAsFixed(1).replaceAll('.', ',');
    } else {
      returnedNumber = num.toStringAsFixed(1);
    }

    return '$returnedNumber$suffix';
  }

  Future<void> translatePost(String originalText, int index) async {
    //first I check if cachedTranslations contains the original text as a key
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
      if (originalText == '') {
        if (mounted) {
          setState(() {
            PostHelper.cachedTranslations[originalText] = '';
          });
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
  }

  void navigateToEditPost(String postContent, String postID) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: CreatePost(
              isEditing: true,
              isCommenting: false,
              originalText: postContent,
              postID: postID,
            ),
          );
        },
      ),
    ).then((result) async {
      await loadUpdate();
    });
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
    ).then((result) async {
      await loadUpdate();
    });
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
    ).then((result) async {
      await loadUpdate();
    });
  }

  void navigateToViewProfile(String postID, String posterID) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: ViewProfile(posterID: posterID, postID: postID),
          );
        },
      ),
    ).then((result) async {
      await loadUpdate();
    });
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
    ).then((result) async {
      await loadUpdate();
    });
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
    ).then((result) async {
      await loadUpdate();
    });
  }

  void navigateToComments(String postID) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Comments(postID: postID)));
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
          print("Current Length:${postData.length}");
          if (postData.isEmpty && index == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (index >= postData.length - 5) {
            searchPosts(searchParams["search"], scrolling: true);
            if (index >= postData.length) {
              return null;
            }
            return _buildPost(index);
          }
          return _buildPost(index);
        },
      ),
    );
  }

  Future<void> loadDelete(String postID) async {
    await PostHelper.deletePost(postID);
    var dataCall =
        await PostHelper.getPosts('None', postData.length, specialSearchArgs);
    if (mounted) {
      setState(() {
        postData.clear();
        postData.addAll(dataCall);
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        if (convertedFetch - 1 >= 0) {
          searchParams["lastPostFetched"] =
              dataCall[dataCall.length - 1]['_id'];
        } else {
          searchParams["lastPostFetched"] = 'None';
        }
      });
    }
  }

  Future<void> loadRemovalToggle(String postID) async {
    await PostHelper.toggleRemoval(postID);
    var dataCall =
        await PostHelper.getPosts('None', postData.length, specialSearchArgs);
    if (mounted) {
      setState(() {
        postData.clear();
        postData.addAll(dataCall);
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        if (convertedFetch - 1 >= 0) {
          searchParams["lastPostFetched"] =
              dataCall[dataCall.length - 1]['_id'];
        } else {
          searchParams["lastPostFetched"] = 'None';
        }
      });
    }
  }

  Future<void> loadUpdate() async {
    var dataCall =
        await PostHelper.getPosts('None', postsPerFetch, specialSearchArgs);
    if (mounted) {
      setState(() {
        postData.clear();
        postData.addAll(dataCall);
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        if (convertedFetch - 1 >= 0) {
          searchParams["lastPostFetched"] =
              dataCall[dataCall.length - 1]['_id'];
        } else {
          searchParams["lastPostFetched"] = 'None';
        }
      });
    }
  }

  void refresh() {
    loadUpdate();
  }

  Future<void> removalAlertDialog(
      BuildContext context, String postID, bool removed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text((removed)
              ? 'Do you wish to approve this post?'
              : 'Do you wish to remove this post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await loadRemovalToggle(postID);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPost(int index) {
    String imageURL = postData[index]["profilePicture"]['url'];
    String attachmentURL = 'Empty';
    if (postData[index]['attachedImage'] != 'Empty') {
      attachmentURL = postData[index]['attachedImage']['url'];
    }
    String posterName = postData[index]["username"];
    String postContent = postData[index]["content"];
    String postID = postData[index]["_id"];
    String posterID = postData[index]['userID'];
    String reportNumber = postData[index]['reports'];
    late int likes = postData[index]['likes'];
    bool posterIsAdmin = false;
    bool userIsAdmin = false;
    //These booleans below may come in handy when we are making admin views
    bool deleted = false;
    bool removed = false;
    if (AuthHelper.userInfoCache['admin'] == 'True') {
      userIsAdmin = true;
    }
    bool isEdited = false;
    var liked = postData[index]['liked'];
    var reportedByUser = postData[index]['reportedByUser'];
    var unreviewedReport = postData[index]['unreviewedReport'];
    if (postData[index]['edited'] == 'True') {
      isEdited = true;
    }
    if (postData[index]['posterIsAdmin'] == 'True') {
      posterIsAdmin = true;
    }
    if (postData[index]['deleted'] == 'True') {
      deleted = true;
    }
    if (postData[index]['removed'] == 'True') {
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

    String commentNumber = postData[index]['comments'].toString();

    PopupMenuButton<String> threeDotMenu = PopupMenuButton<String>(
      onSelected: (String result) async {
        // Handle the selected option
        if (result == 'closeMenu') {
          // Closes menu and does absolutely nothing
        } else if (result == 'editPost') {
          navigateToEditPost(postData[index]["content"], postID);
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

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 50),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
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
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      navigateToViewProfile(postID, posterID);
                      loadUpdate();
                    },
                    child: Row(children: [
                      Text(
                        posterName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Inter',
                          fontSize: 22,
                        ),
                      ),
                      (posterIsAdmin)
                          ? Icon(Icons.shield,
                              color: Color.fromRGBO(4, 57, 39, 100))
                          : const SizedBox(),
                    ]),
                  ),
                ],
              ),
              Expanded(child: const SizedBox()),
              Container(
                child: threeDotMenu,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 5),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(width: 1.0, color: Colors.grey)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (userIsAdmin)
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
                            : const SizedBox(),
                        (attachmentURL != 'Empty')
                            ? Container(
                                padding: EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    navigateToViewImage([attachmentURL]);
                                  },
                                  child: Container(
                                    height: 340,
                                    width: 340,
                                    color: Colors.black,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "$attachmentURL?tr=w-340,h-340,fo-auto",
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            navigateToComments(postID);
                          },
                          child: RichText(
                            maxLines: null,
                            softWrap: true,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: (currentlyTranslated
                                            .containsKey(postID))
                                        ? unescape.convert(PostHelper
                                            .cachedTranslations[postContent]!)
                                        : postContent,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                      fontSize: 18,
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
                          ),
                        ),
                        postTooLong
                            ? Container(
                                child: GestureDetector(
                                  onTap: () {
                                    navigateToComments(postID);
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
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await translatePost(postContent, index);
                                  if (postData[index]['translations'] == '') {
                                    await PostHelper.storeTranslation(
                                        PostHelper
                                            .cachedTranslations[postContent]!,
                                        postData[index]['_id']);
                                  }
                                  if (mounted) {
                                    setState(() {
                                      if (currentlyTranslated
                                          .containsKey(postID)) {
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
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    var response =
                                        await PostHelper.likePost(postID);
                                    setState(() {
                                      postData[index]['liked'] = !liked;

                                      liked = !liked;

                                      if (liked) {
                                        postData[index]['likes']++;
                                      } else {
                                        postData[index]['likes']--;
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
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/PostUI/icon-heart.svg',
                                              color: Colors.black,
                                              height: 30,
                                              width: 30,
                                            )
                                          ],
                                        )
                                      : SvgPicture.asset(
                                          'assets/PostUI/icon-heart.svg',
                                          color: Colors.black,
                                          height: 30,
                                          width: 30,
                                        ),
                                ),
                                Text(formattedLikes,
                                    style: const TextStyle(fontSize: 14))
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    navigateToComments(postID);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/PostUI/icon-comment.svg",
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Text(commentNumber,
                                    style: const TextStyle(fontSize: 14))
                              ],
                            ),
                            (userIsAdmin)
                                ? const SizedBox(width: 10)
                                : const SizedBox(),
                            (userIsAdmin)
                                ? Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            navigateToAdminView(postID);
                                          },
                                          child: SvgPicture.asset(
                                            "assets/PostUI/icon-flag.svg",
                                            height: 30,
                                            width: 30,
                                            color: (unreviewedReport)
                                                ? Colors.deepOrange
                                                : Colors.black,
                                          )),
                                      Text(reportNumber,
                                          style: const TextStyle(fontSize: 14))
                                    ],
                                  )
                                : const SizedBox(),
                            (userIsAdmin)
                                ? (deleted)
                                    ? const SizedBox()
                                    : const SizedBox(width: 10)
                                : const SizedBox(),
                            (userIsAdmin)
                                ? (deleted)
                                    ? const SizedBox()
                                    : GestureDetector(
                                        onTap: () async {
                                          await removalAlertDialog(
                                              context, postID, removed);
                                        },
                                        child: (removed)
                                            ? SvgPicture.asset(
                                                "assets/PostUI/icon-approve.svg",
                                                height: 30,
                                                width: 30,
                                                color: Colors.green,
                                              )
                                            : Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: SvgPicture.asset(
                                                  "assets/PostUI/icon-remove.svg",
                                                  height: 24,
                                                  color: Colors.red,
                                                ),
                                              ))
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget AdminOptions() {
    Widget emptyBox = const SizedBox();
    Color unselected = const Color(0xaa000000);
    Color toggleColor = unselected;
    if (adminOptionsToggled) {
      toggleColor = Colors.black;
    }

    Color unselectedOption = const Color(0xffF2F0F4);
    Color selectedOption = const Color(0xffC9C9C9);
    Color selectedText = Colors.black;
    Color unselectedText = unselected;

    return SizedBox(
      height: (adminOptionsToggled) ? 343 : 25,
      width: 400,
      child: Stack(
        children: [
          Positioned(
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  adminOptionsToggled = !adminOptionsToggled;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    adminOptionsToggled
                        ? Localize("Close Admin Options")
                        : Localize("Open Admin Options"),
                    style: TextStyle(color: toggleColor),
                  ),
                  SvgPicture.asset(
                    "assets/PostUI/icon-adminoptions.svg",
                    color: toggleColor,
                  ),
                ],
              ),
            ),
          ),
          (adminOptionsToggled)
              ? Positioned(
                  top: 40,
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: 500,
                  ),
                )
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 144,
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: 500,
                  ),
                )
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 243,
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: 500,
                  ),
                )
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  bottom: 0,
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: 400,
                  ),
                )
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 60,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Localize("Show Reported Posts")),
                    ],
                  ))
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 100,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showReported'] = 'All';
                          await loadUpdate();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: (specialSearchArgs['showReported'] == 'All')
                                ? selectedOption
                                : unselectedOption,
                          ),
                          child: Text(
                            Localize("All"),
                            style: TextStyle(
                                color:
                                    (specialSearchArgs['showReported'] == 'All')
                                        ? selectedText
                                        : unselectedText),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showReported'] = 'Only';
                          await loadUpdate();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: (specialSearchArgs['showReported'] == 'Only')
                                ? selectedOption
                                : unselectedOption,
                          ),
                          child: Text(
                            Localize("Only"),
                            style: TextStyle(
                                color: (specialSearchArgs['showReported'] ==
                                        'Only')
                                    ? selectedText
                                    : unselectedText),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showReported'] = 'Unreviewed';
                          await loadUpdate();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: (specialSearchArgs['showReported'] ==
                                    'Unreviewed')
                                ? selectedOption
                                : unselectedOption,
                          ),
                          child: Text(
                            Localize("Unreviewed"),
                            style: TextStyle(
                                color: (specialSearchArgs['showReported'] ==
                                        'Unreviewed')
                                    ? selectedText
                                    : unselectedText),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 156,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Localize("Show Removed Posts")),
                    ],
                  ))
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 196,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showRemoved'] = 'All';
                          await loadUpdate();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: (specialSearchArgs['showRemoved'] == 'All')
                                ? selectedOption
                                : unselectedOption,
                          ),
                          child: Text(
                            Localize("All"),
                            style: TextStyle(
                                color:
                                    (specialSearchArgs['showRemoved'] == 'All')
                                        ? selectedText
                                        : unselectedText),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showRemoved'] = 'Only';
                          await loadUpdate();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: (specialSearchArgs['showRemoved'] == 'Only')
                                ? selectedOption
                                : unselectedOption,
                          ),
                          child: Text(
                            Localize("Only"),
                            style: TextStyle(
                                color:
                                    (specialSearchArgs['showRemoved'] == 'Only')
                                        ? selectedText
                                        : unselectedText),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showRemoved'] = 'None';
                          await loadUpdate();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: (specialSearchArgs['showRemoved'] == 'None')
                                ? selectedOption
                                : unselectedOption,
                          ),
                          child: Text(
                            Localize("None"),
                            style: TextStyle(
                                color:
                                    (specialSearchArgs['showRemoved'] == 'None')
                                        ? selectedText
                                        : unselectedText),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 252,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Localize("Show Deleted Posts")),
                    ],
                  ),
                )
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 292,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showDeleted'] = 'All';
                          await loadUpdate();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: (specialSearchArgs['showDeleted'] == 'All')
                                ? selectedOption
                                : unselectedOption,
                          ),
                          child: Text(
                            Localize("All"),
                            style: TextStyle(
                                color:
                                    (specialSearchArgs['showDeleted'] == 'All')
                                        ? selectedText
                                        : unselectedText),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showDeleted'] = 'Only';
                          await loadUpdate();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: (specialSearchArgs['showDeleted'] == 'Only')
                                ? selectedOption
                                : unselectedOption,
                          ),
                          child: Text(
                            Localize("Only"),
                            style: TextStyle(
                                color:
                                    (specialSearchArgs['showDeleted'] == 'Only')
                                        ? selectedText
                                        : unselectedText),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showDeleted'] = 'None';
                          await loadUpdate();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: (specialSearchArgs['showDeleted'] == 'None')
                                ? selectedOption
                                : unselectedOption,
                          ),
                          child: Text(
                            Localize("None"),
                            style: TextStyle(
                                color:
                                    (specialSearchArgs['showDeleted'] == 'None')
                                        ? selectedText
                                        : unselectedText),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )
              : emptyBox,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool userIsAdmin = false;
    if (AuthHelper.userInfoCache['admin'] == 'True') {
      userIsAdmin = true;
    }
    return Scaffold(
      backgroundColor: const Color(0xffece7d5),
      appBar: AppBar(
        backgroundColor: const Color(0xffece7d5),
        automaticallyImplyLeading: false,
        title: SearchBarWidget(
          listSetState: setState,
          list: postData,
          searchParams: searchParams,
        ),
        toolbarHeight: 40,
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          (userIsAdmin)
              ? AdminOptions()
              : const SizedBox(
                  height: 10,
                ),
          Expanded(
            child: (postData.isNotEmpty)
                ? _buildList()
                : Center(
                    child: Text(Localize("No Posts Found")),
                  ),
          )
        ],
      ),
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  final Function listSetState;
  List list;
  final Function listFetcher;
  Map searchParams;

  static dummyFetcher(String value) async {}

  SearchBarWidget(
      {super.key,
      required this.listSetState,
      required this.list,
      required this.searchParams,
      this.listFetcher = dummyFetcher});

  @override
  State<SearchBarWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final Set<dynamic> defaultList = {};

  @override
  void initState() {
    super.initState();
  }

  //what to do we want to do?

  void performSearch(String value) async {
    //add all items to set
    widget.searchParams["search"] = value;
    widget.searchParams["lastPostFetched"] = 'None';
    await addAllItemsToSet();
    if (value.isEmpty) {
      widget.listSetState(() {
        widget.list.clear();
        for (var item in defaultList) {
          widget.list.add(item);
        }
      });
      return;
    }
    String type = inferListItemsType();
    List newList = [];
    if (type == "map") {
      //output, all strings in list
      for (var item in defaultList) {
        for (var entry in item.entries) {
          //lower case both values
          if (entry.value is String) {
            if (entry.value.toLowerCase().contains(value.toLowerCase())) {
              newList.add(item);
              break;
            }
          }
        }
      }
      widget.list.clear();
      for (var item in newList) {
        widget.list.add(item);
      }
      print("WidgetList length${widget.list.length}");
      widget.listSetState(() {});
    }
  }

  String inferListItemsType() {
    if (defaultList.elementAt(0) is Map) {
      return "map";
    } else if (defaultList.elementAt(0) is String) {
      return "string";
    } else {
      //output error
      throw Exception("List items are not of type map or string");
    }
  }

  addAllItemsToSet() async {
    for (var item in widget.list) {
      defaultList.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        performSearch(_controller.text);
      },
      decoration: InputDecoration(
        hintText: Localize('Search'),
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
