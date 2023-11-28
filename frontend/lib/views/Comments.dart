import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/AdminView.dart';
import 'package:frontend/views/ConfirmReport.dart';
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
  //for the parents of the post
  var parentData = [];
  bool viewParents = false;

  Future load() async {
    var dataCall = await PostHelper.getPostByID(widget.postID);
    var comCall = await PostHelper.getComments(widget.postID);
    var parCall = await PostHelper.getParents(widget.postID);
    Map comCallMap = {};
    Map parCallMap = {};
    /*for (var item in comCall) {
      comCallMap[item["_id"]] = item;
    }
    var arrayOfCurrentIds = [];
    for (var item in commentData) {
          arrayOfCurrentIds.add(item['_id']);
        }
    for (var item in dataCall) {
        //only input items with unique id's
        if (!arrayOfCurrentIds.contains(item['_id'])) {
          commentData.add(item);
        }
        }*/
    if (mounted) {
      setState(() {
        fetched = true;
        post = dataCall;
        commentData = comCall;
        parentData = parCall.reversed.toList();
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

  Future<void> loadDelete(String postID) async {
    await PostHelper.deletePost(postID);
    await load();
  }

  Future<void> loadRemovalToggle(String postID) async {
    await PostHelper.toggleRemoval(postID);
    await load();
  }

  Future<void> loadUpdate() async {
    await load();
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
                isEditing: true,
                isCommenting: true,
                originalText: postContent,
                postID: postID),
          );
        },
      ),
    ).then((result) async {
      await loadUpdate();
    });
  }

  void navigateToViewProfile(String postID, String posterID) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: ViewProfile(postID: postID, posterID: posterID),
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
            MaterialPageRoute(builder: (context) => Comments(postID: postID)))
        .then((result) async {
      await loadUpdate();
    });
  }

  void navigateToCreateComment(String postID) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreatePost(
                  postID: postID,
                  isEditing: false,
                  isCommenting: true,
                ))).then((result) async {
      await loadUpdate();
    });
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
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> translatePost(String originalText, var post) async {
    //first I check if cachedTranslations contains the original text as a key
    if (PostHelper.cachedTranslations.containsKey(originalText)) {
      return;
    } else if (post['translations'] != '') {
      if (mounted) {
        setState(() {
          print(PostHelper.cachedTranslations[originalText]);
          print(post['translations']);
          PostHelper.cachedTranslations[originalText] = post['translations'];
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

    return _buildComment(0, [post]);
  }

  Widget _buildList() {
    print('WE GOT HERE');
    int comShift = 0;
    if (commentData.isEmpty) {
      comShift += 1;
    }
    int parShift = 0;
    if (!viewParents) {
      parShift = parentData.length;
    }
    return RefreshIndicator(
      onRefresh: () => loadUpdate(),
      child: ListView.builder(
        itemCount:
            commentData.length + 3 + parentData.length - parShift + comShift,
        itemBuilder: (BuildContext context, int index) {
          if (index < parentData.length && viewParents) {
            return _buildComment(index, parentData, true);
          }

          if (index == parentData.length - parShift) {
            return const Divider(
              height: 3,
              color: Colors.black,
            );
          }

          if (index == parentData.length + 1 - parShift) {
            return _buildPost();
          }

          if (index == parentData.length + 2 - parShift) {
            return const Divider(
              height: 3,
              color: Colors.black,
            );
          }

          if (commentData.isEmpty &&
              index == parentData.length + 3 - parShift) {
            return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                    child: Text(
                  Localize('No Comments Found'),
                  style: const TextStyle(fontSize: 20),
                )));
          }

          return _buildComment(index - parentData.length - 3 + parShift);
        },
      ),
    );
  }

  Widget _buildComment(int index, [var postPassed, var parentPassed]) {
    var parentOverride = false;
    if (parentPassed != null) {
      parentOverride = true;
    }
    var dataSource = commentData;
    if (postPassed != null) {
      dataSource = postPassed;
    }
    String imageURL = dataSource[index]["profilePicture"]['url'];
    String attachmentURL = 'Empty';
    if (dataSource[index]['attachedImage'] != 'Empty') {
      attachmentURL = dataSource[index]['attachedImage']['url'];
    }
    String posterName = dataSource[index]["username"];
    String postContent = dataSource[index]["content"];
    String postID = dataSource[index]["_id"];
    String posterID = dataSource[index]['userID'];
    String reportNumber = dataSource[index]['reports'];
    late int likes = dataSource[index]['likes'];
    bool posterIsAdmin = false;
    bool userIsAdmin = false;
    //These booleans below may come in handy when we are making admin views
    bool deleted = false;
    bool removed = false;
    if (AuthHelper.userInfoCache['admin'] == 'True') {
      userIsAdmin = true;
    }
    bool isEdited = false;
    var liked = dataSource[index]['liked'];
    var reportedByUser = dataSource[index]['reportedByUser'];
    var unreviewedReport = dataSource[index]['unreviewedReport'];
    if (dataSource[index]['edited'] == 'True') {
      isEdited = true;
    }
    if (dataSource[index]['posterIsAdmin'] == 'True') {
      posterIsAdmin = true;
    }
    if (dataSource[index]['deleted'] == 'True') {
      deleted = true;
    }
    if (dataSource[index]['removed'] == 'True') {
      removed = true;
    }
    var unescape = HtmlUnescape();

    String formattedLikes = formatLargeNumber(likes);
    postContent = postContent.replaceAll('\n', ' ');

    String commentNumber = dataSource[index]['comments'].toString();

    PopupMenuButton<String> threeDotMenu = PopupMenuButton<String>(
      onSelected: (String result) async {
        // Handle the selected option
        if (result == 'closeMenu') {
          // Closes menu and does absolutely nothing
        } else if (result == 'editPost') {
          navigateToEditPost(dataSource[index]["content"], postID);
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
                          ? const Icon(Icons.shield,
                              color: Color.fromRGBO(4, 57, 39, 100))
                          : const SizedBox(),
                    ]),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Container(
                child: threeDotMenu,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 5),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
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
                                padding: const EdgeInsets.only(top: 10),
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
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                          maxLines: null,
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      (currentlyTranslated.containsKey(postID))
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
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var postTarget = post;
                                  if (postPassed == null) {
                                    var postTarget = commentData[index];
                                  }
                                  await translatePost(postContent, postTarget);
                                  if (dataSource[index]['translations'] == '') {
                                    await PostHelper.storeTranslation(
                                        PostHelper
                                            .cachedTranslations[postContent]!,
                                        dataSource[index]['_id']);
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
                                      dataSource[index]['liked'] = !liked;

                                      liked = !liked;

                                      if (liked) {
                                        dataSource[index]['likes']++;
                                      } else {
                                        dataSource[index]['likes']--;
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
                            (postPassed != null)
                                ? Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/PostUI/icon-comment.svg",
                                        height: 30,
                                        width: 30,
                                      ),
                                      Text(commentNumber,
                                          style: const TextStyle(fontSize: 14))
                                    ],
                                  )
                                : const SizedBox(),
                            (userIsAdmin && postPassed != null)
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
                                                    const EdgeInsets.only(top: 5),
                                                child: SvgPicture.asset(
                                                  "assets/PostUI/icon-remove.svg",
                                                  height: 24,
                                                  color: Colors.red,
                                                ),
                                              ))
                                : const SizedBox(),
                          ],
                        ),
                        (postPassed != null)
                            ? Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () async {
                                          navigateToCreateComment(postID);
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.reply,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              Localize("Reply to User"),
                                              style: const TextStyle(fontSize: 20),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              )
                            : const SizedBox(),
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
          title: Text(
            Localize("Comments"),
            textAlign: TextAlign.center,
            style: const TextStyle(
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
        body: _buildList());
  }
}
