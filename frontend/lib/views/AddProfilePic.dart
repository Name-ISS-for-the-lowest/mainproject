import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/SignupComplete.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lottie/lottie.dart';

class AddToProfilePic extends StatefulWidget {
  const AddToProfilePic({super.key});

  @override
  State<AddToProfilePic> createState() => _AddToProfilePicState();
}

class _AddToProfilePicState extends State<AddToProfilePic> {
  bool imageSpecified = false;
  Widget imageWidget = Image.asset('assets/Default_pfp.png',
      width: 200, height: 200, fit: BoxFit.fill);

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        File getImage = File(pickedFile.path);
        setState(() {
          imageWidget = Image.file(getImage, fit: BoxFit.fill);
          imageSpecified = true;
        });
      }
    } catch (e) {
      print("${Localize("Error picking image:")} $e");
    }
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(Localize("Choose an option")),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await pickImage(ImageSource.camera);
              },
              child: Text(Localize("Take a photo")),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await pickImage(ImageSource.gallery);
              },
              child: Text(Localize("Choose from gallery")),
            ),
          ],
        );
      },
    );
  }

  void navigateToFinishSignUp() {
    //navigate back to login
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: Stack(children: [
              SizedBox(
                height: 100,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
              const SignupComplete()
            ]),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 57, 39, 1.0),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true, // Extend content behind the AppBar
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        iconTheme: const IconThemeData(
            color: Colors.white), // Set the back arrow color
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          //Background animation (increase top offset value to move anim down, decrease to move up)
          Positioned(
              top: 200,
              child: SizedBox(
                height: screenHeight,
                child: LottieBuilder.asset(
                  'assets/BackgroundWave.json',
                  fit: BoxFit.fill,
                ),
              )),

          //Returning User Form begins Here--------------------------
          Positioned(
            top: 100,
            child: SingleChildScrollView(
                child: Column(
              children: [
                //This part is just text and formatting
                SizedBox(
                  width: 280,
                  child: Text(
                    Localize('Add Profile Picture'),
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Spacer for Column elements
                const SizedBox(
                  height: 25,
                ),

                SizedBox(
                  width: 300,
                  child: Text(
                    Localize(
                        'Finally, add an image that you want to use to represent yourself'),
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromRGBO(230, 183, 17, 1)),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Spacer for Column elements
                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: 300,
                  child: Text(
                    Localize(
                        "Please be mindful of other users, Avoid using images that may be considered disturbing or offensive. Images should be inline with Sac State's Hornet Honor Code policy"),
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromRGBO(230, 183, 17, 1)),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Spacer for Column elements
                const SizedBox(
                  height: 20,
                ),

                //Spacer for Column elements
                const SizedBox(
                  height: 20,
                ),

                //Email Field Styling

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
                                child: Hero(
                                  tag: Localize('profile_pic'),
                                  child: Container(
                                    width: 150, // set your desired width
                                    height: 150, // set your desired height
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: imageWidget,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              left: 100,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    iconSize: 50,
                                    onPressed: () async {
                                      _showImagePickerDialog(context);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                Positioned(
                  bottom: 42,
                  child: Column(children: [
                    SizedBox(
                        height:
                            100), // Add spacing between the profile picture and the next button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(330, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        backgroundColor: const Color.fromRGBO(221, 151, 26, 1),
                        foregroundColor: const Color.fromRGBO(93, 78, 63, 1),
                        textStyle: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: Text(Localize('Next')),
                      onPressed: () => {
                        navigateToFinishSignUp(),
                      },
                    ),
                  ]
                      //Next Button Styling
                      ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
