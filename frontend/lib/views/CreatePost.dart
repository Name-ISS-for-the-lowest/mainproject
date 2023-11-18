import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  void navigateToPrimaryScreens() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: CoreTemplate(),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    var userInfo = AuthHelper.userInfoCache;
    String imageURL = userInfo['profilePicture.url'];
    String screenName = userInfo['username'];
    String currentPostBody = "";
    String userID = userInfo['_id'];
    return Scaffold(
      backgroundColor: Color(0xffece7d5),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 75,
              width: 412,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    left: 5,
                    bottom: 5,
                    child: GestureDetector(
                      onTap: () {
                        navigateToPrimaryScreens();
                      },
                      child: SvgPicture.asset(
                        "assets/icon-x.svg",
                        width: 20,
                        height: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    child: Text(
                      "New Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.0, // Set the desired height of the line
              color: Color(0x5f000000),
              margin: EdgeInsets.symmetric(vertical: 0),
            ),
            Container(
              width: 412,
              height: 814,
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    top: 10,
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
                    left: 34.5,
                    top: 70,
                    child: Container(
                      width: 1,
                      height: 200,
                      color: Color(0x5f000000),
                      margin: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                  Positioned(
                    top: 22.5,
                    left: 70,
                    child: Text(
                      screenName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 22.5,
                    child: GestureDetector(
                      onTap: () async {
                        var response = await PostHelper.createPost(
                            userID, currentPostBody);
                        navigateToPrimaryScreens();
                      },
                      child: Text(
                        "Publish Post",
                        style: TextStyle(
                          color: Color(0xff007EF1),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    top: 50,
                    child: Container(
                        width: 280,
                        height: 500,
                        child: TextField(
                          controller: TextEditingController(),
                          decoration: InputDecoration(
                            hintText: 'Begin Typing',
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (text) {
                            currentPostBody = text;
                          },
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
