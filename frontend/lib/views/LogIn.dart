import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/views/ResetPassword.dart';
import 'package:frontend/views/SignUp.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void executeLogin(String email, String password) {
    //do something with the email and password
  }

  void navigateToSignUp() {
    //navigate to sign up page
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
              const SignUp()
            ]),
          );
        },
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: SvgPicture.asset(
                  'assets/BackGround.svg',
                  fit: BoxFit.fitHeight,
                )),
          ),
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
                child: Text("Log In",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(230, 183, 17, 1))),
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
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelText: 'Email',
                              contentPadding: const EdgeInsets.all(18),
                              fillColor: Colors.white,
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                        )
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
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelText: 'Password',
                              contentPadding: const EdgeInsets.all(18),
                              fillColor: Colors.white,
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
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
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              onPressed: () => {
                                executeLogin(emailController.text,
                                    passwordController.text)
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
                        )
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
                                    borderRadius: BorderRadius.circular(10.0)),
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
                        )
                      ],
                    )
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
                  child: const Text("Forgot Password?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(230, 183, 17, 1),
                      )),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
