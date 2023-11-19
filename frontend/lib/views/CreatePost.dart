import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CreatePost extends StatefulWidget {
  final bool isEditing;
  final String? originalText;
  final String? postID;
  const CreatePost(
      {super.key, required this.isEditing, this.originalText, this.postID});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  void navigateToPrimaryScreens() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const Scaffold(
            body: CoreTemplate(),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    var userInfo = AuthHelper.userInfoCache;
    bool isEditing = widget.isEditing;
    String? originalText = widget.originalText;
    String? originalID = widget.postID;
    String imageURL = userInfo['profilePicture.url'];
    String screenName = userInfo['username'];
    String currentPostBody;
    String postID;
    if (originalText == null) {
      currentPostBody = "";
    } else {
      currentPostBody = originalText;
    }
    if (originalID == null) {
      postID = "";
    } else {
      postID = originalID;
    }
    String userID = userInfo['_id'];

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
            onTap: () => navigateToPrimaryScreens(),
          ),
          title: Text(
            (isEditing) ? "Edit Post" : "New Post",
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
              height: 1.0, // Set the desired height of the line
              color: const Color(0x5f000000),
            ),
          )),
      backgroundColor: const Color(0xffece7d5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        screenName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    if (isEditing) {
                      var response =
                          await PostHelper.editPost(postID, currentPostBody);
                    } else {
                      var response =
                          await PostHelper.createPost(userID, currentPostBody);
                    }

                    navigateToPrimaryScreens();
                  },
                  child: const Text(
                    "Publish Post",
                    style: TextStyle(
                      color: Color(0xff007EF1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                width: 45,
                height: 200,
                decoration: const BoxDecoration(
                  //only set right border
                  border: Border(
                    right: BorderSide(
                      color: Color(0x5f000000),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 200,
                  child: TextField(
                    controller: TextEditingController(text: currentPostBody),
                    decoration: const InputDecoration(
                      hintText: 'Begin Typing',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (text) {
                      currentPostBody = text;
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
