import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/views/CreatePost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/views/CreatePost.dart';
import 'package:frontend/views/ReportPage.dart';

class ForumHome extends StatefulWidget {
  const ForumHome({super.key});

  @override
  State<ForumHome> createState() => _ForumHomeState();
}

class _ForumHomeState extends State<ForumHome> {
  final List postData = [];
  final int postsPerFetch = 15;
  Map searchParams = {"search": "", "postsFetched": 0};
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
      searchParams["postsFetched"] = 0;
      postData.clear();
    }
    // print("I am fetching posts");
    // print("Posts Fetched:$postsFetched");
    // print("Posts Per Fetch:$postsPerFetch");
    if (search == "") {
      try {
        var dataCall = await PostHelper.getPosts(
            searchParams["postsFetched"], postsPerFetch);
        print("Data Call:$dataCall");
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
        searchParams["postsFetched"] += fetchedLength;
        if (firstLoad) {
          firstLoad = false;
          setState(() {});
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
            searchParams["postsFetched"],
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
        searchParams["postsFetched"] += fetchedLength;
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
      var translationCall = await PostHelper.getTranslation(originalText);
      if (mounted) {
        setState(() {
          String returnedTranslation = translationCall['result'];
          PostHelper.cachedTranslations[originalText] = returnedTranslation;
        });
      }
    }
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

  void deletePost(String postID) {
    loadDelete(postID);
  }

  Widget _buildList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        print("Current Index:$index");
        print("Current Length:${postData.length}");
        if (postData.isEmpty && index == 0) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (index >= postData.length) {
          searchPosts(searchParams["search"], scrolling: true);
          return null;
        }
        return _buildPost(index);
      },
    );
  }

  Future<void> loadDelete(String postID) async {
    await PostHelper.deletePost(postID);
    var dataCall = await PostHelper.getPosts(
        0, searchParams["postsFetched"], specialSearchArgs);
    if (mounted) {
      setState(() {
        postData.clear();
        postData.addAll(dataCall);
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        searchParams["postsFetched"] = convertedFetch;
      });
    }
  }

  Future<void> loadRemovalToggle(String postID) async {
    await PostHelper.toggleRemoval(postID);
    var dataCall = await PostHelper.getPosts(
        0, searchParams['postsFetched'], specialSearchArgs);
    if (mounted) {
      setState(() {
        postData.clear();
        postData.addAll(dataCall);
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        searchParams["postsFetched"] = convertedFetch;
      });
    }
  }

  Future<void> loadUpdate() async {
    var dataCall = await PostHelper.getPosts(
        0, searchParams['postsFetched'], specialSearchArgs);
    if (mounted) {
      setState(() {
        postData.clear();
        postData.addAll(dataCall);
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        searchParams["postsFetched"] = convertedFetch;
      });
    }
  }

  Widget _buildPost(int index) {
    String imageURL = postData[index]["profilePicture"]['url'];
    String posterName = postData[index]["username"];
    String postContent = postData[index]["content"];
    String postID = postData[index]["_id"];
    String posterID = postData[index]['userID'];
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
                    text: (currentlyTranslated.containsKey(postID))
                        ? PostHelper.cachedTranslations[postContent]
                        : postContent,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                    )),
                if (isEdited)
                  TextSpan(
                    text: Localize('(Edited)'),
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
          deletePost(postID);
        } else if (result == 'reportPost') {
          navigateToReportPost(postID);
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
                    Localize('Edit Post'),
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
                    Localize('Delete Post'),
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
                    Localize('Report Post'),
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

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
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
                        text: ' [${Localize("Admin")}]',
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
                            "[${Localize('Deleted By User')}]",
                            style: TextStyle(color: Colors.red),
                          )
                        : (removed)
                            ? Text(
                                "[${Localize('Post Removed')}]",
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
              left: 85,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Comment Tapped")));
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
                  await translatePost(postContent, index);
                  if (postData[index]['translations'] == '') {
                    await PostHelper.storeTranslation(
                        PostHelper.cachedTranslations[postContent]!,
                        postData[index]['_id']);
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
                              content: Text(Localize(
                                  "Expanded Post (should go to same place as comments)"))));
                        },
                        child: Container(
                          width: 250,
                          child: Text(
                            Localize(
                                "Post too tall to view on home page. Please click here to expand post."),
                            style: TextStyle(
                              color: Color(0x55000000),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget AdminOptions() {
    Widget emptyBox = const SizedBox();
    Color unselected = Color(0xaa000000);
    Color toggleColor = unselected;
    if (adminOptionsToggled) {
      toggleColor = Colors.black;
    }
    return Container(
      height: (adminOptionsToggled) ? 295 : 25,
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
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showReported'] = 'All';
                          await loadUpdate();
                        },
                        child: Text(
                          Localize("All"),
                          style: TextStyle(
                              color:
                                  (specialSearchArgs['showReported'] == 'All')
                                      ? Colors.black
                                      : unselected),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showReported'] = 'Only';
                          await loadUpdate();
                        },
                        child: Text(
                          Localize("Only"),
                          style: TextStyle(
                              color:
                                  (specialSearchArgs['showReported'] == 'Only')
                                      ? Colors.black
                                      : unselected),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                )
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 140,
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
                  top: 180,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showRemoved'] = 'All';
                          await loadUpdate();
                        },
                        child: Text(
                          Localize("All"),
                          style: TextStyle(
                              color: (specialSearchArgs['showRemoved'] == 'All')
                                  ? Colors.black
                                  : unselected),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showRemoved'] = 'Only';
                          await loadUpdate();
                        },
                        child: Text(
                          Localize("Only"),
                          style: TextStyle(
                              color:
                                  (specialSearchArgs['showRemoved'] == 'Only')
                                      ? Colors.black
                                      : unselected),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showRemoved'] = 'None';
                          await loadUpdate();
                        },
                        child: Text(
                          Localize("None"),
                          style: TextStyle(
                              color:
                                  (specialSearchArgs['showRemoved'] == 'None')
                                      ? Colors.black
                                      : unselected),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                )
              : emptyBox,
          (adminOptionsToggled)
              ? Positioned(
                  top: 220,
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
                  top: 260,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showDeleted'] = 'All';
                          await loadUpdate();
                        },
                        child: Text(
                          Localize("All"),
                          style: TextStyle(
                              color: (specialSearchArgs['showDeleted'] == 'All')
                                  ? Colors.black
                                  : unselected),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showDeleted'] = 'Only';
                          await loadUpdate();
                        },
                        child: Text(
                          Localize("Only"),
                          style: TextStyle(
                              color:
                                  (specialSearchArgs['showDeleted'] == 'Only')
                                      ? Colors.black
                                      : unselected),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          specialSearchArgs['showDeleted'] = 'None';
                          await loadUpdate();
                        },
                        child: Text(
                          Localize("None"),
                          style: TextStyle(
                              color:
                                  (specialSearchArgs['showDeleted'] == 'None')
                                      ? Colors.black
                                      : unselected),
                        ),
                      ),
                      Spacer(),
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
      backgroundColor: Color(0xffece7d5),
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
            child: (postData.length > 0)
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
    widget.searchParams["postsFetched"] = 0;
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
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
