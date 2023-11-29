import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/views/AddProfilePic.dart';

class PasswordSetUp extends StatefulWidget {
  final String email;
  String password = "";
  PasswordSetUp({super.key, required this.email});

  @override
  State<PasswordSetUp> createState() => _PasswordState();
}

class _PasswordState extends State<PasswordSetUp> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void navigateToAddProfilePic(String email, String password) {
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
              AddToProfilePic(email: email, password: password)
            ]),
          );
        },
      ),
    );
  }

  bool validatePassword(String password) {
    final passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    bool validPassword = passwordRegExp.hasMatch(password);
    if (!validPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localize(
              "Password must be at least 8 characters long, have one uppercase letter, one lowercase letter, and one number")),
        ),
      );
      //show error message
      return false;
    }
    //make sure passwords match
    if (password != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localize("Passwords do not match")),
        ),
      );
      return false;
    }
    widget.password = password;
    return true;
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
          Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: screenHeight * 0.6,
                child: LottieBuilder.asset(
                  'assets/BackgroundWave.json',
                  fit: BoxFit.fill,
                ),
              )),

          //Returning User Form begins Here--------------------------
          Column(
            children: [
              //This part is just text and formatting
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SizedBox(
                  width: 260,
                  child: Text(
                    Localize('Password Setup'),
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              SizedBox(
                width: 300,
                child: Text(
                  Localize(
                      'Next, please create a suitable password for your new account.'),
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
                height: 20,
              ),
              SizedBox(
                width: 330,
                height: 55,
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: Localize('Confirm Password'),
                    contentPadding: const EdgeInsets.all(18),
                    fillColor: Colors.white,
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),

              SizedBox(
                height: 200,
              ),
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
                onPressed: () {
                  if (validatePassword(passwordController.text)) {
                    navigateToAddProfilePic(widget.email, widget.password);
                  }
                },
              ),
            ],
          ),

          //Next button Formatting
        ],
      ),
    );
  }
}
