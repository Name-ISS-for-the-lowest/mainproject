import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/views/ResetPassword.dart';
import 'package:frontend/views/SignUp.dart';
import 'package:frontend/views/CoreTemplate.dart';
import 'package:lottie/lottie.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class BackgroundWidget extends StatelessWidget{
  const BackgroundWidget({super.key});
  
  @override
  Widget build(BuildContext context){ 
    final screenHeight = MediaQuery.sizeOf(context).height;
    //final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 57, 39, 1.0),
      body: Stack(
        children: [
          Positioned(
            top: 200,
            child: SizedBox(
            height: screenHeight,
            child: LottieBuilder.asset('assets/BackgroundWave.json',
              fit: BoxFit.fill,),
          )) 
        ],
        )
      );
  }
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
        content: Text(response.data["message"] ?? "Error"),
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
            //I kept the email in the text field
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const Scaffold(
            body: CoreTemplate(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
 
    final screenHeight = MediaQuery.sizeOf(context).height;
    //final screenWidth = MediaQuery.sizeOf(context).width;
    const BackgroundWidget();
    return Scaffold(
      
      backgroundColor: const Color.fromRGBO(4, 57, 39, 1.0),
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
            top: 260,
            child: Column(
            
                  children: [  
          
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
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.white,
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
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
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
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white
                          ),
                          textAlign:TextAlign.end,
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

                        child: const Text('Log In'),
                        onPressed: () => {
                          executeLogin(context, emailController.text, passwordController.text)
                        },
                     ),
                    
                ],
            )
          ),


          Positioned(
            bottom: 42,
            child: Column(
                children: [

                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromRGBO(230, 183, 17, 1)
                          ),
                      ),

                    const SizedBox(
                      height: 9,
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

                      child: const Text('Sign Up'),
                      onPressed: () => {
                        navigateToSignUp()
                      },
                    ),
                ],
              ),

            ),
        ],
        )
      );

    
    
    /*return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 57, 39, 1.0),
      body: Stack(
        children: [
          Container(
            color: const Color.fromRGBO(0, 78, 56, 1),
            width: screenWidth,
            height: 400,
          ),  
          Align(
            alignment: const Alignment(0,0.5),
            child: SizedBox(
                  height: screenHeight * .5,
                  child: Lottie.asset('assets/BackgroundWave.json',
                    height: screenHeight,
                    width: screenWidth,
                    fit: BoxFit.fitWidth,
                  )
                  ))   
                  ],
      ),
    );*/
    
    /*final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.60,
                ),
                SizedBox(
                  height: screenHeight * 0.40,
                  child: Lottie.asset(
                    'assets/BackgroundWave.json',
                    height: 800,
                    width: screenWidth,
                    fit: BoxFit.fill,
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
                      "Log In",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(230, 183, 17, 1),
                      ),
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
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 50,
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
                                    executeLogin(context, emailController.text,
                                        passwordController.text),
                                  },
                                  child: const Text(
                                    "Login",
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
                                        const Color.fromRGBO(221, 151, 26, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () => {
                                    navigateToSignUp(),
                                  },
                                  child: const Text(
                                    "Sign Up",
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
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () => {
                        navigateToResetPassword(),
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(230, 183, 17, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );*/
  }
}
