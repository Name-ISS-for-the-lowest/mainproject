import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String profilePicture = "assets/DefaultPFPs/pfp-mrwhiskers.png";
    String displayName = "Mr. Whiskers";
    String nationality = "Brazilian";
    String emailAddress = "mrwhiskers@csus.edu";

    return Scaffold(
        backgroundColor: Color(0xffece7d5),
        // body: Center(child: Text("Profile Page")),

        body: ListView(
          children: [
            Stack(
              children: <Widget>[
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      profilePicture,
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
                Positioned.fill(
                  left: 140,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 50,
                      )),
                ),
              ],
            ),

            // Container(
            //   child: Image.asset(
            //     profilePicture,
            //     height: 150,
            //     width: 150,
            //     //trailing: Icon(Icons.camera_alt),
            //   ),

            // ),

            //USERNAME
            Container(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Display Name'),
                subtitle: Text(displayName),
                trailing: Icon(Icons.edit_note),
              ),
            ),

            //NATIONALITY
            Container(
              child: ListTile(
                leading: Icon(Icons.flag),
                title: Text('Nationality'),
                subtitle: Text(nationality),
                trailing: Icon(Icons.edit_note),
              ),
            ),

            Container(
              child: ListTile(
                leading: Icon(Icons.mail),
                title: Text('Email Address'),
                subtitle: Text(emailAddress),
              ),
            ),

            Container(
              child: ListTile(
                leading: Icon(Icons.delete),
                iconColor: Colors.redAccent,
                title: Text('Delete Account'),
                subtitle: Text('This action cannot be restored.'),
                textColor: Colors.redAccent,
              ),
            ),
          ],
        ));
  }
}
