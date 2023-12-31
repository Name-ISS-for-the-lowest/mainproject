import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/ResetPassword.dart';
import 'package:frontend/views/SignUp.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:frontend/views/SignupComplete.dart';
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
    if (!validateEmail(email)) {
      return;
    }
    var response = await AuthHelper.login(email, password);
    bool check = await AuthHelper.isLoggedIn();
    if (check) {
      navigateToPrimaryScreens();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.data["message"] ?? Localize("Error")),
      ));
    }

    if (response.data["message"] == "Please verify your email") {
      //navigate to verify email page
      navigateToFinishSignUp();
    }
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

  bool validateEmail(String email) {
    //check if @example.com
    final exampleRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@example\.com$');
    if (exampleRegExp.hasMatch(email)) {
      return true;
    }
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
    //make sure email is not over 100 characters
    if (email.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localize('Email must be less than 50 characters')),
        ),
      );
      return false;
    }
    return true;
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CoreTemplate()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
        backgroundColor: const Color.fromRGBO(4, 57, 39, 1.0),
        resizeToAvoidBottomInset: false,
        body: Stack(
          //make full width and height

          children: [
            //Background animation (increase top offset value to move anim down, decrease to move up)
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

            // Returning User Form begins Here--------------------------
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //This part is just text and formatting
                Align(
                  child: SizedBox(
                      height: 200,
                      width: 300,
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
                ),

                // Spacer for Column elements
                const SizedBox(
                  height: 50,
                ),

                // //Email Field Styling
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

                // //Spacer for Column elements
                const SizedBox(
                  height: 20,
                ),

                // //Password Field Styling
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

                // //Spacer for Column elements
                const SizedBox(
                  height: 11,
                ),

                // //Reset Password Link Styling
                SizedBox(
                  // width: 330,
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

                // //Spacer for Column elements
                const SizedBox(
                  height: 12,
                ),

                // //Log In Button Styling
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
                    executeLogin(
                        context, emailController.text, passwordController.text)
                  },
                ),
                const SizedBox(
                  height: 200,
                ),
                SizedBox(
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
                          backgroundColor:
                              const Color.fromRGBO(221, 151, 26, 1),
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
            ),

            //New User Forms Begin here -------------------------------
          ],
        ));
  }
}
