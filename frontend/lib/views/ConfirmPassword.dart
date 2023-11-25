import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/views/AddProfilePic.dart';
import 'package:lottie/lottie.dart';


class ConfirmPassword extends StatefulWidget {
  const ConfirmPassword({super.key});

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  void navigateToAddProfilePic() {
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
              const AddToProfilePic()
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
                          Localize('Confirm Password'),
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
                            Localize('Almost there! Please confirm the password you just created by entering it one more time.'),
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
                        height: 30,
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
                            labelText: Localize('Confirm Password'),
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
                        navigateToAddProfilePic()
                    },
                  ),),
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
        physics:
            const NeverScrollableScrollPhysics(), // This line makes it non-scrollable
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
                      Localize("Confirm Password"),
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
                          "Almost there! Please confirm the password you just created by entering it one more time."),
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
                                //controller: emailController,
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
                          height: 300,
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
                                  onPressed: () => {navigateToAddProfilePic()},
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