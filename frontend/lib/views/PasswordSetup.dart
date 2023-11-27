import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/views/ConfirmPassword.dart';
import 'package:lottie/lottie.dart';

class PasswordSetUp extends StatefulWidget {
  final String email;
  String password = "";
  PasswordSetUp({super.key, required this.email});

  @override
  State<PasswordSetUp> createState() => _PasswordState();
}

class _PasswordState extends State<PasswordSetUp> {
  TextEditingController passwordController = TextEditingController();

  void navigateToConfirmPassword(String email, String password) {
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
              ConfirmPassword(
                email: email,
                password: password,
              ),
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
                      Localize('Password Setup'),
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

                  SizedBox(
                    width: 340,
                    child: Text(
                      Localize(
                          'For security purposes, please make sure that your password contains a series of numbers, letters, and other special characters.'),
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
                          'DON\'T share your password with other users or third-parties. It should only be known by the owner of the account'),
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
              onPressed: () {
                if (validatePassword(passwordController.text)) {
                  navigateToConfirmPassword(widget.email, widget.password);
                }
              },
            ),
          ),
        ],
      ),
    );

    /* @override
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
        physics: const NeverScrollableScrollPhysics(),
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
                      Localize("Password Setup"),
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
                          "Next, please create a suitable password for your new account."),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                          "Password must be at least 8 characters long, have one uppercase letter, one lowercase letter, and one number"),
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
                          height: 150,
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
                                    if (validatePassword(
                                        passwordController.text))
                                      {
                                        navigateToConfirmPassword(
                                            widget.email, widget.password),
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
  }*/
  }
}
