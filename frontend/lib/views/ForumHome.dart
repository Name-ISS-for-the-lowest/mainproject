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
      print(dataCall);
      print("hello ther");
      setState(() {
        postData = dataCall;
        init = true;
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        postsFetched += convertedFetch;
      });
    }
  }

  void reload() {
    addData();
  }

  Future<void> addData() async {
    //Add a sleep here to simulate loading
    // await Future.delayed(const Duration(seconds: 5));
    print('hi');
    var dataCall =
        await PostHelper.getPosts(postsFetched, postsFetched + postsPerFetch);
    if (mounted) {
      setState(() {
        postData.addAll(dataCall);
        num fetchedLength = dataCall.length;
        int convertedFetch = fetchedLength.toInt();
        postsFetched += convertedFetch;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      firstload();
    }

    List<Container> postArray = [];
    List<String> sampleImages = [
      'assets/pfp-mrwhiskers.png',
      'assets/pfp-goodboy.png',
      'assets/pfp-kevin.png'
    ];
    List<String> posterNames = ['Mr. Whiskers', 'Good Boy', 'Kevin'];
    List<String> animalNoises = ['Meow.', 'Woof Woof.', 'Caw Caw.'];

    return Scaffold(
      backgroundColor: Color(0xffece7d5),
      body: ListView.builder(
        itemCount: postData.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          int postIndex = index % 3;
          String imageURL = sampleImages[postIndex];
          String posterName = posterNames[postIndex];
          String postContent = postData[index]["content"];
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
                  postContent,
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
                  child: Image.asset(
                    imageURL,
                    height: 50,
                    width: 50,
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
                          "assets/icon-3dots.svg",
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Heart Tapped")));
                    },
                    child: SvgPicture.asset(
                      "assets/icon-heart.svg",
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 33,
                  left: 80,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Comment Tapped")));
                    },
                    child: SvgPicture.asset(
                      "assets/icon-comment.svg",
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 33,
                  left: 280,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Translate Tapped")));
                    },
                    child: Text(
                      "Translate",
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
