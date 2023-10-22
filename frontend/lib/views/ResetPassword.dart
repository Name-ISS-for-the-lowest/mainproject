import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
                child: Text("Reset Password",
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
                  ],
                )
              ],
            ),
            Column(
              children: [
                Column(
                  children: [
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
                                    const Color.fromRGBO(230, 183, 17, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              onPressed: () => {},
                              child: const Text(
                                "Send Recovery Email",
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
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
