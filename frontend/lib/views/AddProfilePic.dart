import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddToProfilePic extends StatefulWidget {
  const AddToProfilePic({super.key});

  @override
  State<AddToProfilePic> createState() => _AddToProfilePicState();
}

class _AddToProfilePicState extends State<AddToProfilePic> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        // You can use the pickedFile.path to access the selected image file
        // Do something with the selected image (e.g., update profile picture)
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Choose an option"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _pickImage(ImageSource.camera);
              },
              child: Text("Take a photo"),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _pickImage(ImageSource.gallery);
              },
              child: Text("Choose from gallery"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String imageURL = "";
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend content behind the AppBar
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        iconTheme:
            IconThemeData(color: Colors.white), // Set the back arrow color
      ),
      body: SingleChildScrollView(
        physics:
            NeverScrollableScrollPhysics(), // This line makes it non-scrollable
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: SvgPicture.asset(
                    'assets/BackGround.svg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                //spacer for top
                const SizedBox(
                  height: 100,
                ),
                //Log in title
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Add Profile Picture",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(230, 183, 17, 1),
                      ),
                      textAlign: TextAlign.center, // Center-align the text
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Finally, add an image that you want to use to represent yourself ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(230, 183, 17, 1),
                      ),
                      textAlign: TextAlign.center, // Center-align the text
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Please be mindful of other users, Avoid using images that may be considered disturbing or offensive. Images should be inline with Sac State’s Hornet Honor Code policy",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(230, 183, 17, 1),
                      ),
                      textAlign: TextAlign.center, // Center-align the text
                    ),
                  ),
                ),
                //Input fields
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    //going to have to add the circle that lets you add the profile picture
                    Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            Positioned(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 150, // set your desired width
                                  height: 150, // set your desired height
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      imageURL.isNotEmpty
                                          ? "$imageURL?tr=w-200,h-200,fo-auto"
                                          : 'assets/Default_pfp.png', // Provide a placeholder image URL or local asset,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              left: 140,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    iconSize: 50,
                                    onPressed: () {
                                      _showImagePickerDialog(context);
                                    }),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                Column(
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: 340,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    230, 183, 17, 1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          onPressed: () => {
                                            // enter logic to go to confirm password screen
                                          },
                                          child: const Text(
                                            "Next",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 53, 53, 53),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
