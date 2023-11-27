import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/views/PasswordSetup.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  String email = "";
  SignUp({super.key, required this.email});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();

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
    if (!emailRegExp.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localize('Invalid email, must be a CSUS email')),
        ),
      );
      return false;
    }
    widget.email = email;
    return true;
  }

  void navigateToPassWordSetUp(String email) {
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
              PasswordSetUp(email: email)
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
                        Localize('Welcome to the I.S.S!'),
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
                            'Before we begin, please enter a valid Sacramento State email.'),
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
                            'These can be identified by the “@csus.edu” handle near the end like this:'),
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
                        Localize('“Example@csus.edu”'),
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromRGBO(255, 255, 255, 1)),
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
                          contentPadding: const EdgeInsets.all(18),
                          fillColor: Colors.white,
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                  ],
                ))),

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
                  if (validateEmail(emailController.text))
                    {
                      navigateToPassWordSetUp(emailController.text),
                    }
                },
              ),
            )
            //Next Button Styling
          ],
        ));
  }
}
