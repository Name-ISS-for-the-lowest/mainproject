//import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:dio/dio.dart';
import 'package:frontend/views/PasswordSetup.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

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
        SnackBar(
          content: Text(Localize('Invalid email, must be a CSUS email')),
        ),
      );
      return;
    }
    if (!validPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localize("Password must be at least 8 characters long, have one uppercase letter, one lowercase letter, and one number")),
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
            resizeToAvoidBottomInset: false,
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
 
    final screenHeight = MediaQuery.sizeOf(context).height;
    
    return Scaffold(
      
      backgroundColor: const Color.fromRGBO(4, 57, 39, 1.0),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true, // Extend content behind the AppBar
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        iconTheme:
            const IconThemeData(color: Colors.white), // Set the back arrow color
      ),

      body: Stack(

        alignment: Alignment.center,
        children: [

          //Background animation (increase top offset value to move anim down, decrease to move up)
          Positioned(
            top: 200,
            child: SizedBox(
            height: screenHeight,
            child: LottieBuilder.asset('assets/BackgroundWave.json',
              fit: BoxFit.fill,),
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
                      child : Text(
                          Localize('Welcome to the I.S.S!'),
                          style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 45,
                                color: Color.fromRGBO(230, 183, 17, 1)
                              ),
                          textAlign: TextAlign.center,
                        ),
                    ),

                    //Spacer for Column elements
                    const SizedBox(
                        height: 25,
                    ),

                    SizedBox(
                      width: 300,
                      child : Text(
                          Localize('Before we begin, please enter a valid Sacramento State email.'),
                          style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromRGBO(230, 183, 17, 1)
                              ),
                          textAlign: TextAlign.center,
                        ),
                    ),

                    //Spacer for Column elements
                    const SizedBox(
                        height: 20,
                    ),

                    SizedBox(
                      width: 300,
                      child : Text(
                          Localize('These can be identified by the “@csus.edu” handle near the end like this:'),
                          style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromRGBO(230, 183, 17, 1)
                              ),
                          textAlign: TextAlign.center,
                        ),
                    ),

                    //Spacer for Column elements
                    const SizedBox(
                        height: 20,
                    ),

                    SizedBox(
                      width: 300,
                      child : Text(
                          Localize('“Example@csus.edu”'),
                          style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1)
                              ),
                          textAlign: TextAlign.center,
                        ),
                    ),
                    
                    
                    //Spacer for Column elements
                    const SizedBox(
                      height: 20,
                    ),

                    //Email Field Styling

                    SizedBox(
                        width: 330,
                        height: 55,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: Localize('Email'),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ), 
                ],
              )
            )
          ),

          Positioned(
            bottom: 42,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(330, 50),
                      shape: RoundedRectangleBorder( 
                          borderRadius: BorderRadius.circular(5.0)),
                      backgroundColor: const Color.fromRGBO(230, 183, 17, 1),
                      foregroundColor: const Color.fromRGBO(93, 78, 63, 1),
                      textStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16, 
                        ), 
                  ),

                  child: Text(Localize('Next')),
                    onPressed: () => {
                      navigateToPassWordSetUp(),
                  },
          ),)
          //Next Button Styling
          
        ],
        )
      );
  }

  /*@override
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
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: Lottie.asset(
                    'assets/BackgroundWave.json',
                    height: 800,
                    width: 800,
                    fit: BoxFit.fill
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
      ),
    );
  }*/
}
