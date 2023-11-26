import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/views/ConfirmPassword.dart';
import 'package:lottie/lottie.dart';

class PasswordSetUp extends StatefulWidget {
  const PasswordSetUp({super.key});

  @override
  State<PasswordSetUp> createState() => _PasswordState();
}

class _PasswordState extends State<PasswordSetUp> {
  bool validateEmail(String email) {
    //general email regex
    // final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    //csus email regex
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@csus\.edu$');
    return emailRegExp.hasMatch(email);
  }

  void navigateToConfirmPassword() {
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
              const ConfirmPassword()
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
            child: Column(
            
                  children: [  
                    
                    //This part is just text and formatting
                    SizedBox(
                      width: 240,
                      child : Text(
                          Localize('Password Setup'),
                          style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 45,
                                color: Color.fromRGBO(255, 255, 255, 1)
                              ),
                          textAlign: TextAlign.center,
                        ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    

                    SizedBox(
                        width: 300,
                        child : Text(
                            Localize('Next, please create a suitable password for your new account.'),
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
                        width: 340,
                        child : Text(
                            Localize('For security purposes, please make sure that your password contains a series of numbers, letters, and other special characters.'),
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
                            Localize('DON\'T share your password with other users or third-parties. It should only be known by the owner of the account'),
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
                    
                      //Password Field Styling
                      SizedBox(         
                        width: 330,
                        height: 55,
                        child: TextField(
                          //controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: Localize('Password'),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior:
                              FloatingLabelBehavior.never,
                          ),
                        ),
                      ),
                      
                      //Spacer for Column elements
                      const SizedBox(
                        height: 20,
                      ),
                   
                ],
            )
          ),


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
                    onPressed: () => {
                        navigateToConfirmPassword()
                    },
                  ),),
                ],
              ),

            );
  }
}