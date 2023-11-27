import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/views/AddProfilePic.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:dio/dio.dart';

class ConfirmPassword extends StatefulWidget {
  final String email;
  final String password;
  String confirmPassword = "";
  ConfirmPassword({super.key, required this.email, required this.password});

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  TextEditingController passwordController = TextEditingController();

  void navigateToAddProfilePic(String email) {
    //navigate to AddProfilePic page
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
              AddToProfilePic(email: email)
            ]),
          );
        },
      ),
    );
  }

  bool validateConfirmPassword(String confirmPassword) {
    if (confirmPassword != widget.password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localize("Passwords do not match")),
        ),
      );
      //show error message
      return false;
    }
    widget.confirmPassword = confirmPassword;
    return true;
  }

  Future<void> executeSignUp(String email, String password) async {
    //need to do email validation to make sure email is not garbage
    //also should have password validation minimum 8 characters, etc
    Response response = await AuthHelper.signUp(email, password);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.data["message"] ?? "Error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const NeverScrollableScrollPhysics(), // This line makes it non-scrollable
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
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      Localize("Confirm Password"),
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(230, 183, 17, 1),
                      ),
                      textAlign: TextAlign.center, // Center-align the text
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      Localize(
                          "Almost there! Please confirm the password you just created by entering it one more time."),
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
                    Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 340,
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: Localize('Password'),
                                  contentPadding: const EdgeInsets.all(18),
                                  fillColor: Colors.white,
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
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
                Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 300,
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
                                        const Color.fromRGBO(230, 183, 17, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () async => {
                                    if (validateConfirmPassword(
                                        passwordController.text))
                                      {
                                        await executeSignUp(
                                            widget.email, widget.password),
                                        navigateToAddProfilePic(widget.email)
                                      }
                                  },
                                  child: Text(
                                    Localize("Next"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 53, 53, 53),
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
      ),
    );
  }
}
