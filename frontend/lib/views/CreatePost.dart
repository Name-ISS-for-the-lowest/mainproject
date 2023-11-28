import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const Scaffold(
              body: CoreTemplate(),
            );
          },
        ),
      );
    }
  }

  File? imageAttachment;
  String currentPostBody = "";
  bool isSubmitting = false;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    if (mounted) {
      setState(() {
        imageAttachment = File(image.path);
      });
    }
    Navigator.of(context).pop();
  }

  Future pickCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    if (mounted) {
      setState(() {
        imageAttachment = File(image.path);
      });
    }
    Navigator.of(context).pop();
  }

  void openCameraDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Theme(
          data: Theme.of(context)
              .copyWith(dialogBackgroundColor: const Color(0xfff7ebe1)),
          child: SimpleDialog(
            title: Text(Localize("Image Source")),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(Localize('Select from Gallery')),
                onPressed: () => pickImage(),
              ),
              SimpleDialogOption(
                child: Text(Localize('Open Camera')),
                onPressed: () => pickCamera(),
              ),
              SimpleDialogOption(
                child: Text(Localize('Close')),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var userInfo = AuthHelper.userInfoCache;
    bool isEditing = widget.isEditing;
    String? originalText = widget.originalText;
    String? originalID = widget.postID;
    String imageURL = userInfo['profilePicture.url'];
    String screenName = userInfo['username'];
    String postID;
    if (originalText != null) {
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
            (isEditing) ? Localize("Edit Post") : Localize("New Post"),
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
                    if (currentPostBody == '') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please add some content to your post."),
                      ));
                      return;
                    }
                    if (isEditing) {
                      var response =
                          await PostHelper.editPost(postID, currentPostBody);
                    } else {
                      if (isSubmitting == false) {
                        setState(() {
                          isSubmitting = true;
                        });
                        var response = await PostHelper.createPost(
                            userID, currentPostBody, imageAttachment);
                      }
                    }

                    navigateToPrimaryScreens();
                  },
                  child: Text(
                    Localize("Publish Post"),
                    style: const TextStyle(
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
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 200,
                      child: TextField(
                        controller:
                            TextEditingController(text: currentPostBody),
                        decoration: InputDecoration(
                          hintText: Localize("Begin Typing"),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, top: 0),
                    child: GestureDetector(
                      onTap: () {
                        openCameraDialog(context);
                      },
                      child: SvgPicture.asset(
                        'assets/PostUI/photos.svg',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          (isEditing == false)
              ? SizedBox(
                  height: 500,
                  width: 400,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20,
                        right: 25,
                        height: 350,
                        width: 350,
                        child: (imageAttachment != null)
                            ? Stack(
                                children: [
                                  Positioned(
                                    child: Image.file(
                                      imageAttachment!,
                                      height: 350,
                                      width: 350,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        imageAttachment = null;
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        'assets/PostUI/icon-xcircle.svg',
                                        color: Colors.grey,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
