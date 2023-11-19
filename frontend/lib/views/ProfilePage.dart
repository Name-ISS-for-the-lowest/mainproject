import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}







class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    //USER VARIABLES
    String imageURL = AuthHelper.userInfoCache['profilePicture.url'];
    String displayName = AuthHelper.userInfoCache['username'];
    String nationality = AuthHelper.userInfoCache['nationality'];
    String language =
        AuthHelper.languageNames[AuthHelper.userInfoCache['language']];
    String emailAddress = AuthHelper.userInfoCache['email'];
    Language _selectedDialogLanguage = Languages.english;


//COUNTRY SELECTOR
  void countryselect()
  {
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
  }

  Widget _buildDialogItem(Language language){
    return Row(
      children: <Widget>[
        SizedBox(
          width: 0.0,
        ),
        Text("${language.name}"),
        //Text("${language.name} ({$language.isoCode})"),
      ],
    );
  }

  //Language WHITELIST
  final supportedLanguages = [
    Languages.english,
    Languages.korean,









  ];

//LANGUAGE SELECTOR
  void _openLanguagePickerDialog() => showDialog(
      context: context,
      builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: LanguagePickerDialog(
              //languages: supportedLanguages,
              titlePadding: EdgeInsets.all(8.0),
              //searchCursorColor: Colors.pinkAccent,
              searchInputDecoration: InputDecoration(hintText: 'Search'),
              isSearchable: true,
              
              title: Text('Select your language'),
              onValuePicked: (Language language) => setState(() {
                    _selectedDialogLanguage = language;
                    print(_selectedDialogLanguage.name);
                    print(_selectedDialogLanguage.isoCode);
                  }),
              itemBuilder: _buildDialogItem)),
  );

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
                    child: Container(
                      width: 150, // Set your desired width
                      height: 150, // Set your desired height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: "$imageURL?tr=w-150,h-150,fo-auto",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
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
                      onPressed: () {},
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
                  onPressed: () {
                    countryselect();
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
                  onPressed: () {
                    //OPEN THE LANGUAGE SELECTOR
                    _openLanguagePickerDialog();
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
                onTap: () {},
              ),
            ),
          ],
        ));
  }
}
