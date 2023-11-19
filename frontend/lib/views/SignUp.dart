import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:dio/dio.dart';
import 'package:frontend/views/PasswordSetup.dart';

class SignUp extends StatefulWidget {
  String email = "";
  SignUp({super.key, required this.email});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //on mount
  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  bool validateEmail(String email) {
    //general email regex
    // final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    //csus email regex
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@csus\.edu$');
    return emailRegExp.hasMatch(email);
  }

  bool validatePassword(String password) {
    final passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  void executeSignUp(String email, String password) async {
    final validEmail = validateEmail(email);
    //might remove this since we must match flow we have in figma
    final validPassword = validatePassword(password);
    if (!validEmail) {
      //show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email, must be a CSUS email'),
        ),
      );
      return;
    }
    if (!validPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Password must be at least 8 characters long, have one uppercase letter, one lowercase letter, and one number"),
        ),
      );
      //show error message
      return;
    }
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

  void navigateToPassWordSetUp() {
    //navigate to confirm email page
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
              const PasswordSetUp()
            ]),
          );
        },
      ),
    );
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
      body: Stack(
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
                height: 120,
              ),
              //Log in title
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Welcome to the I.S.S.!",
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
                    "Before we begin, please enter a valid Sacramento State email",
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
                    "These can be identified by the “@csus.edu” handle near the end like this:",
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
                    "“Example@csus.edu”",
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
                              controller: emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Email',
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
                      /*
                        Column(
                          children: [
                            SizedBox(
                              width: 340,
                              child: TextField(
                                obscureText: true,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: 'Password',
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
                        */
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 180,
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
                                onPressed: () => {
                                  navigateToPassWordSetUp(),
                                },
                                child: const Text(
                                  "Next",
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
    );
  }
}
