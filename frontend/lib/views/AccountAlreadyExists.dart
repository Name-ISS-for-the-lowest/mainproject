import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/views/LogIn.dart';
import 'package:lottie/lottie.dart';

class AccountAlreadyExists extends StatefulWidget {
  const AccountAlreadyExists({super.key});

//varibles

  @override
  State<AccountAlreadyExists> createState() => _AccountAlreadyExistsState();
}

class _AccountAlreadyExistsState extends State<AccountAlreadyExists> {
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
              ),
            ),

            //Returning User Form begins Here--------------------------
            SingleChildScrollView(
                child: Column(
              children: [
                //This part is just text and formatting
                SizedBox(
                  width: 350,
                  child: Text(
                    Localize('Account Already Exists'),
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
                    Localize('Please login or reset password to continue.'),
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
                        'We hope you enjoy your time with us. Press the button below at any time to return to the login page and begin browsing.'),
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromRGBO(230, 183, 17, 1)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
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
                  child: Text(Localize('Return to Login')),
                  onPressed: () => {
                    navigateBacktoLogIn(),
                  },
                ),
              ],
            )),

            //Next Button Styling
          ],
        ));
  }
}
