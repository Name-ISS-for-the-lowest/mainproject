import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/auth_helper.dart';

class ForumHome extends StatefulWidget {
  const ForumHome({super.key});

  @override
  State<ForumHome> createState() => _ForumHomeState();
}

class _ForumHomeState extends State<ForumHome> {
  @override
  Widget build(BuildContext context) {
    List<Container> postArray = [];
    List<String> sampleImages = [
      'assets/pfp-mrwhiskers.png',
      'assets/pfp-goodboy.png',
      'assets/pfp-kevin.png'
    ];
    List<String> posterNames = ['Mr. Whiskers', 'Good Boy', 'Kevin'];
    List<String> animalNoises = ['Meow.', 'Woof Woof.', 'Caw Caw.'];

    for (var i = 0; i < 50; i++) {
      int postIndex = i % 3;
      String imageURL = sampleImages[postIndex];
      String posterName = posterNames[postIndex];
      String postContent =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco. ';
      postContent += animalNoises[postIndex];
      double calculatedHeight = (postContent.length / 35 * 14 * 1.8);

      Container x = Container(
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
              child: Container(
                width: 280,
                child: Text(
                  postContent,
                  softWrap: true,
                ),
              ),
            ),
            Positioned(
              bottom: 33,
              left: 50,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Heart Tapped")));
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
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Comment Tapped")));
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
          ],
        ),
      );

      postArray.add(x);
    }
    return Scaffold(
      backgroundColor: Color(0xffece7d5),
      body: ListView(children: postArray),
    );
  }
}
