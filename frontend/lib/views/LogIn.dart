
import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/ResetPassword.dart';
import 'package:frontend/views/SignUp.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AuthHelper.isLoggedIn().then((value) {
      if (value) {
        navigateToPrimaryScreens();
      }
    });
  }

  void executeLogin(BuildContext context, email, String password) async {
    //do something with the email and password
    var response = await AuthHelper.login(email, password);
    bool check = await AuthHelper.isLoggedIn();
    if (check) {
      navigateToPrimaryScreens();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.data["message"] ?? Localize("Error")),
      ));
    }
  }

  void navigateToSignUp() {
    passwordController.text = "";
    //navigate to sign up page
    var result = Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SignUp(email: emailController.text),
          );
        },
      ),
    );
    result.then((value) {
      if (value != null) {
        emailController.text = value;
      }
    });
  }

  void navigateToResetPassword() {
    //navigate to resetpassword page
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
              const ResetPassword()
            ]),
          );
        },
      ),
    );
  }

  void navigateToPrimaryScreens() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => CoreTemplate()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
        backgroundColor: const Color.fromRGBO(4, 57, 39, 1.0),
        resizeToAvoidBottomInset: false,
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
                        height: 100,
                        child: FittedBox(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: Color.fromRGBO(230, 183, 17, 1)),
                            textAlign: TextAlign.center,
                            child: AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  RotateAnimatedText(
                                      transitionHeight: 100,
                                      Localizer.localize('Welcome Back', 'en')),
                                  RotateAnimatedText(
                                      transitionHeight: 100,
                                      Localizer.localize('Welcome Back', 'es')),
                                  RotateAnimatedText(
                                      transitionHeight: 100,
                                      Localizer.localize('Welcome Back', 'fr')),
                                  RotateAnimatedText(
                                      transitionHeight: 100,
                                      Localizer.localize('Welcome Back', 'zh')),
                                ]),
                          ),
                        )),

                    //Spacer for Column elements
                    const SizedBox(
                      height: 45,
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

                    //Spacer for Column elements
                    const SizedBox(
                      height: 21,
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
                          labelText: Localize('Password'),
                          contentPadding: const EdgeInsets.all(18),
                          fillColor: Colors.white,
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),

                    //Spacer for Column elements
                    const SizedBox(
                      height: 11,
                    ),

                    //Reset Password Link Styling
                    SizedBox(
                      width: 330,
                      child: GestureDetector(
                        onTap: () {
                          navigateToResetPassword();
                        },
                        child: Text(
                          Localize('Forgot Password?'),
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),

                    //Spacer for Column elements
                    const SizedBox(
                      height: 12,
                    ),

                    //Log In Button Styling
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
                      child: Text(Localize('Log In')),
                      onPressed: () => {
                        executeLogin(context, emailController.text,
                            passwordController.text)
                      },
                    ),
                  ],
                )),

            //New User Forms Begin here -------------------------------
            Positioned(
              bottom: 42,
              child: Column(
                children: [
                  //This part is just text and formatting
                  Text(
                    Localize('Don\'t have an account?'),
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromRGBO(230, 183, 17, 1)),
                  ),
                  //Spacer
                  const SizedBox(
                    height: 9,
                  ),
                  //Sign Up button Formatting
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
                    child: Text(Localize('Sign Up')),
                    onPressed: () => {navigateToSignUp()},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
