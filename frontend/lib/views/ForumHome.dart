import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/views/CreatePost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/views/CreatePost.dart';

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
  final Map<String, String> currentlyTranslated = {};

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
      var dataCall = await PostHelper.getPosts(
          searchParams["postsFetched"], postsPerFetch);
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
    } else {
      var dataCall = await PostHelper.searchPosts(searchParams["postsFetched"],
          postsPerFetch, search, AuthHelper.userInfoCache["_id"]);
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
    var dataCall = await PostHelper.getPosts(0, searchParams["postsFetched"]);
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
    bool isEdited = false;
    var liked = postData[index]['liked'];
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
          navigateToEditPost(postData[index]["content"], postID);
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
                    var response = await PostHelper.likePost(postID);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'])));
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: _buildList(),
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
