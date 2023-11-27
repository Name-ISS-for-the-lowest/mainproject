import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/views/AddProfilePic.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';

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
    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(response.data["message"] ?? "Error"),
    //     ),
    //   );
    // }
  }

  @override
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
              child: Column(
                children: [
                  //This part is just text and formatting
                  SizedBox(
                    width: 240,
                    child: Text(
                      Localize('Confirm Password'),
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                          color: Color.fromRGBO(255, 255, 255, 1)),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  SizedBox(
                    width: 300,
                    child: Text(
                      Localize(
                          'Almost there! Please confirm the password you just created by entering it one more time.'),
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
                    height: 30,
                  ),

                  //Password Field Styling
                  SizedBox(
                    width: 330,
                    height: 55,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: Localize('Confirm Password'),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),

                  //Spacer for Column elements
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),

          //Next button Formatting
          Positioned(
            bottom: 42,
            child: ElevatedButton(
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
              onPressed: () async => {
                if (validateConfirmPassword(passwordController.text))
                  {
                    await executeSignUp(widget.email, widget.password),
                    navigateToAddProfilePic(widget.email)
                  }
              },
            ),
          ),
        ],
      ),
    );
  }
}
