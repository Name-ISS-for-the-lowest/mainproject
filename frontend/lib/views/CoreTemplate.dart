import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/views/ForumHome.dart';
import 'package:frontend/views/CreatePost.dart';
import 'package:frontend/views/EventsPage.dart';
import 'package:frontend/views/ProfilePage.dart';
import 'package:frontend/views/ResourceCenter.dart';

class CoreTemplate extends StatefulWidget {
  const CoreTemplate({super.key});

  @override
  State<CoreTemplate> createState() => _CoreTemplateState();
}

class _CoreTemplateState extends State<CoreTemplate> {
  int selectedIndex = 0;
  bool isKeyBoardVisable = false;
  final screens = [
    ForumHome(),
    ResourceCenter(),
    CreatePost(),
    EventsPage(),
    ProfilePage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      if (index != 2) {
        selectedIndex = index;
      } else {
        navigateToCreatePost();
      }
    });
  }

  void navigateToCreatePost() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: CreatePost(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffece7d5),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: SvgPicture.asset("assets/iss-small.svg"),
          ),
          Container(
            height: 1.0, // Set the desired height of the line
            color: Color(0x5f000000),
            margin: EdgeInsets.symmetric(vertical: 0),
          ),
          Container(
            height: 734,
            width: 412,
            child: screens[selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
            backgroundColor: Color(0xff08231A),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Color(0xffFFE89A),
            unselectedItemColor: Color(0xff89875A),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/NavBarUI/icon-home.svg',
                      color: Color(0xff89875A)),
                ),
                activeIcon: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/NavBarUI/icon-home.svg',
                      color: Color(0xffFFE89A)),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/NavBarUI/icon-search.svg'),
                ),
                activeIcon: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/NavBarUI/icon-search.svg',
                      color: Color(0xffFFE89A)),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 40,
                  height: 40,
                  child:
                      SvgPicture.asset('assets/NavBarUI/icon-createpost.svg'),
                ),
                activeIcon: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/NavBarUI/icon-createpost.svg',
                      color: Color(0xffFFE89A)),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/NavBarUI/icon-resources.svg',
                      color: Color(0xff89875A)),
                ),
                activeIcon: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/NavBarUI/icon-resources.svg',
                      color: Color(0xffFFE89A)),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/NavBarUI/icon-profile.svg'),
                ),
                activeIcon: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/NavBarUI/icon-profile.svg',
                      color: Color(0xffFFE89A)),
                ),
                label: '',
              ),
            ],
            onTap: onItemTapped,
            currentIndex: selectedIndex),
      ),
    );
  }
}
