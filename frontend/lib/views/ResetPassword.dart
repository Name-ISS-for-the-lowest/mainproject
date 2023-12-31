import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/LogIn.dart';
import 'package:lottie/lottie.dart';

class ResetPassword extends StatefulWidget {
  final String email = "";
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();

  //on mount
  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  void navigateBacktoLogIn() {
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
              const LogIn()
            ]),
          );
        },
      ),
    );
  }

  bool validateEmail(String email) {
    //general email regex
    // final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    //csus email regex
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@csus\.edu$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> executeRestsetPassWord(String email) async {
    final validEmail = validateEmail(email);

    if (!validEmail) {
      //show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localize('Invalid email, must be a CSUS email')),
        ),
      );

      return;
    } else {
      await AuthHelper.resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localize('Email sent')),
        ),
      );
    }
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
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: screenHeight * 0.6,
                child: LottieBuilder.asset(
                  'assets/BackgroundWave.json',
                  fit: BoxFit.fill,
                ),
              ),
            ),

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
                        Localize('Reset Password'),
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
                        Localize('Forgot Password?'),
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
                            "Just enter your account's email and a recovery link will be sent right to you!"),
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
                    const SizedBox(
                      height: 250,
                    ),
                    ElevatedButton(
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
                      child: Text(Localize('Send Recovery Email')),
                      onPressed: () async {
                        await executeRestsetPassWord(emailController.text);
                        navigateBacktoLogIn();
                      },
                    ),
                  ],
                ))),

            //Next Button Styling
          ],
        ));
  }
}
