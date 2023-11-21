import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:frontend/classes/Localize.dart';
// import 'package:language_picker/language_picker.dart';
// import 'package:language_picker/languages.dart';
import '../languagePicker/languages.dart';
import '../languagePicker/language_picker.dart';
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
    void countryselect() {
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

    Widget _buildDialogItem(Language language) {
      return Row(
        children: <Widget>[
          SizedBox(
            width: 0.0,
          ),
          Text("${language.name}"),
          //Text("${language.name}"),
          //Text("${language.name} (${language.isoCode})"),
        ],
      );
    }

    //Language WHITELIST
    final supportedLanguages = [
			Language.fromIsoCode("af"),
			Language.fromIsoCode("sq"),
			Language.fromIsoCode("am"),
			Language.fromIsoCode("ar"),
			Language.fromIsoCode("hy"),
			Language.fromIsoCode("as"),
			Language.fromIsoCode("ay"),
			Language.fromIsoCode("az"),
			Language.fromIsoCode("bm"),
			Language.fromIsoCode("eu"),
			Language.fromIsoCode("be"),
			Language.fromIsoCode("bn"),
			//Language.fromIsoCode("bho"),
			Language.fromIsoCode("bs"),
			Language.fromIsoCode("bg"),
			Language.fromIsoCode("ca"),
			//Language.fromIsoCode("ceb"),
			Language.fromIsoCode("ny"),
			
      //Language.fromIsoCode("zh"),
      Languages.chineseSimplified, //Returns zh_Hans
			//Language.fromIsoCode("zh-TW"),
      Languages.chineseTraditional, //returns zh_Hant
			
      Language.fromIsoCode("co"),
			Language.fromIsoCode("hr"),
			Language.fromIsoCode("cs"),
			Language.fromIsoCode("da"),
			Language.fromIsoCode("dv"),
			//Language.fromIsoCode("doi"),
			Language.fromIsoCode("nl"),
			Language.fromIsoCode("en"),
			Language.fromIsoCode("eo"),
			Language.fromIsoCode("et"),
			Language.fromIsoCode("ee"),
			Language.fromIsoCode("tl"),
			Language.fromIsoCode("fi"),
			Language.fromIsoCode("fr"),
			Language.fromIsoCode("fy"),
			Language.fromIsoCode("gl"),
			Language.fromIsoCode("lg"),
			Language.fromIsoCode("ka"),
			Language.fromIsoCode("de"),
			Language.fromIsoCode("el"),
			Language.fromIsoCode("gn"),
			Language.fromIsoCode("gu"),
			Language.fromIsoCode("ht"),
			Language.fromIsoCode("ha"),
			//Language.fromIsoCode("haw"),
			//Language.fromIsoCode("iw"), HEBREW HE REDUNDANCY
			Language.fromIsoCode("hi"),
			//Language.fromIsoCode("hmn"),
			Language.fromIsoCode("hu"),
			Language.fromIsoCode("is"),
			Language.fromIsoCode("ig"),
			//Language.fromIsoCode("ilo"),
			Language.fromIsoCode("id"),
			Language.fromIsoCode("ga"),
			Language.fromIsoCode("it"),
			Language.fromIsoCode("ja"),
			//Language.fromIsoCode("jw"),
			Language.fromIsoCode("kn"),
			Language.fromIsoCode("kk"),
			Language.fromIsoCode("km"),
			Language.fromIsoCode("rw"),
			//Language.fromIsoCode("gom"),
			Language.fromIsoCode("ko"),
			//Language.fromIsoCode("kri"),
			Language.fromIsoCode("ku"),
			//Language.fromIsoCode("ckb"),
			Language.fromIsoCode("ky"),
			Language.fromIsoCode("lo"),
			Language.fromIsoCode("la"),
			Language.fromIsoCode("lv"),
			Language.fromIsoCode("ln"),
			Language.fromIsoCode("lt"),
			Language.fromIsoCode("lb"),
			Language.fromIsoCode("mk"),
			//Language.fromIsoCode("mai"),
			Language.fromIsoCode("mg"),
			Language.fromIsoCode("ms"),
			Language.fromIsoCode("ml"),
			Language.fromIsoCode("mt"),
			Language.fromIsoCode("mi"),
			Language.fromIsoCode("mr"),
			//Language.fromIsoCode("mni-Mtei"),
			//Language.fromIsoCode("lus"),
			Language.fromIsoCode("mn"),
			Language.fromIsoCode("my"),
			Language.fromIsoCode("ne"),
			//Language.fromIsoCode("nso"),
			Language.fromIsoCode("no"),
			Language.fromIsoCode("or"),
			Language.fromIsoCode("om"),
			Language.fromIsoCode("ps"),
			Language.fromIsoCode("fa"),
			Language.fromIsoCode("pl"),
			Language.fromIsoCode("pt"),
			Language.fromIsoCode("pa"),
			Language.fromIsoCode("qu"),
			Language.fromIsoCode("ro"),
			Language.fromIsoCode("ru"),
			Language.fromIsoCode("sm"),
			Language.fromIsoCode("sa"),
			Language.fromIsoCode("gd"),
			Language.fromIsoCode("sr"),
			Language.fromIsoCode("st"),
			Language.fromIsoCode("sn"),
			Language.fromIsoCode("sd"),
			Language.fromIsoCode("si"),
			Language.fromIsoCode("sk"),
			Language.fromIsoCode("sl"),
			Language.fromIsoCode("so"),
			Language.fromIsoCode("es"),
			Language.fromIsoCode("su"),
			Language.fromIsoCode("sw"),
			Language.fromIsoCode("sv"),
			Language.fromIsoCode("tg"),
			Language.fromIsoCode("ta"),
			Language.fromIsoCode("tt"),
			Language.fromIsoCode("te"),
			Language.fromIsoCode("th"),
			Language.fromIsoCode("ti"),
			Language.fromIsoCode("ts"),
			Language.fromIsoCode("tr"),
			Language.fromIsoCode("tk"),
			Language.fromIsoCode("ak"),
			Language.fromIsoCode("uk"),
			Language.fromIsoCode("ur"),
			Language.fromIsoCode("ug"),
			Language.fromIsoCode("uz"),
			Language.fromIsoCode("vi"),
			Language.fromIsoCode("cy"),
			Language.fromIsoCode("xh"),
			Language.fromIsoCode("yi"),
			Language.fromIsoCode("yo"),
			Language.fromIsoCode("zu"),
			Language.fromIsoCode("he"),
			Language.fromIsoCode("jv"),
			
      //Language.fromIsoCode("zh-CN"), REDUNDANCY WITH ZH
      //Languages.chineseSimplified,
      
    ];

//LANGUAGE SELECTOR
    void _openLanguagePickerDialog() => showDialog(
          context: context,
          builder: (context) => Theme(
              data: Theme.of(context).copyWith(primaryColor: Colors.pink),
              child: LanguagePickerDialog(
                  languages: supportedLanguages,
                  titlePadding: EdgeInsets.all(8.0),
                  //searchCursorColor: Colors.pinkAccent,
                  searchInputDecoration:
                      InputDecoration(hintText: Localize('Search')),
                  isSearchable: true,
                  title: Text(Localize('Select your language')),
                  onValuePicked: (Language language) => setState(() {
                        print(AuthHelper.userInfoCache['language']);
                        
                        if ("zh_Hans".compareTo(language.isoCode) == 0)
                        {
                          AuthHelper.userInfoCache['language'] = 'zh-CN';
                        }
                        else if ("zh_Hant".compareTo(language.isoCode) == 0)
                        {
                          AuthHelper.userInfoCache['language'] = 'zh-TW';
                        }
                        else
                        {
                          AuthHelper.userInfoCache['language'] = language.isoCode;
                        }

                        _selectedDialogLanguage = language;
                        // print(_selectedDialogLanguage.name);
                        // print(_selectedDialogLanguage.isoCode);
                      }),
                  itemBuilder: _buildDialogItem)),
        );


  showDeleteAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {

        return;
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ACCOUNT DELETION"),
      content: Text("THIS ACTION IS IRREVERSABLE. ARE YOU SURE YOU WANT TO CONTINUE?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLogoutAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {

        return;
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Log Out"),
      content: Text("You will be returned to the login screen. Continue?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  

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
                  onPressed: () {},
                ),
              ),
            ),

            //NATIONALITY
            Container(
              child: ListTile(
                leading: Icon(Icons.flag),
                title: Text(Localize('Nationality')),
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
                title: Text(Localize('Language')),
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
                title: Text(Localize('Email Address')),
                subtitle: Text(emailAddress),
              ),
            ),

            //LOG OUT
            Container(
              child: ListTile(
                leading: Icon(Icons.logout),

                //LOCALIZE NOT FUNCTIONING AT THE MOMENT
                //title: Text(Localize('Log Out')),
                //subtitle: Text(Localize('Sign out of the current account.')),
                title: Text('Log Out'),
                subtitle: Text('Sign out of the current account.'),
                onTap: () {

                showLogoutAlertDialog(context);
                  
                },
              ),
            ),

            //DELETE ACCOUNT
            Container(
              child: ListTile(
                leading: Icon(Icons.delete),
                iconColor: Colors.redAccent,
                title: Text(Localize('Delete Account')),
                subtitle: Text(Localize('This action cannot be restored.')),
                textColor: Colors.redAccent,
                onTap: () {

                showDeleteAlertDialog(context);
                  
                },
              ),
            ),
          ],
        ));
  }
}
