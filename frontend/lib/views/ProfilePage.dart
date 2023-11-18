import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:reactive_language_picker/reactive_language_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
    String language = "English";
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
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        iconSize: 50,
                        onPressed: (){
                          
                        },
                      ),
                  ),
                ),
            ],
          ),

          //USERNAME
          Container( 
            child: ListTile(
              //leading: Icon(Icons.person),
              title: Text(
                displayName, 
                textAlign: TextAlign.center,
                textScaleFactor: 2,
                ),
              trailing: IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(Icons.edit_note),
                onPressed: (){

                },
                
              ),
            ),
          ),

          //NATIONALITY
          Container(
            child: ListTile(
              leading: Icon(Icons.flag),
              title: Text('Nationality'),
              subtitle: Text(nationality),
              trailing: IconButton(
                icon: Icon(Icons.edit_note),

                onPressed: (){
                  showCountryPicker(
                    context: context,
                    favorite: <String>['US', 'CN', 'MX', 'IN'],
                    //exclude: <String>['FR'],
                    countryListTheme: CountryListThemeData(
                      backgroundColor: Color(0xffece7d5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    onSelect: (Country country) {
                    print('Select country: ${country.displayName}');
                    },
                  );
                },
              ),
            ),
          ),

          //Language
          Container(
            child: ListTile(
              leading: Icon(Icons.chat_rounded),
              title: Text('Language'),
              subtitle: Text(language),
              trailing: IconButton(
                icon: Icon(Icons.edit_note),
                onPressed: (){
                  
                },
              ),
            ),
          ),

          //EMAIL ADDRESS
          Container(
            child: ListTile(
              leading: Icon(Icons.mail),
              title: Text('Email Address'),
              subtitle: Text(emailAddress),
            ),
          ),

          //DELETE ACCOUNT
          Container(
            child: ListTile(
              leading: Icon(Icons.delete),
              iconColor: Colors.redAccent,
              title: Text('Delete Account'),
              subtitle: Text('This action cannot be restored.'),
              textColor: Colors.redAccent,

              onTap: (){

              },
            ),
          ),

        ],
      )




    );
  }
}
