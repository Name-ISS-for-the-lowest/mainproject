import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffece7d5),
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
                    child: SvgPicture.asset('assets/icon-home.svg',
                        color: Color(0xff89875A)),
                  ),
                  activeIcon: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icon-home.svg',
                        color: Color(0xffFFE89A)),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icon-search.svg'),
                  ),
                  activeIcon: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icon-search.svg',
                        color: Color(0xffFFE89A)),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icon-createpost.svg'),
                  ),
                  activeIcon: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icon-createpost.svg',
                        color: Color(0xffFFE89A)),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icon-resources.svg',
                        color: Color(0xff89875A)),
                  ),
                  activeIcon: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icon-resources.svg',
                        color: Color(0xffFFE89A)),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icon-profile.svg'),
                  ),
                  activeIcon: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icon-profile.svg',
                        color: Color(0xffFFE89A)),
                  ),
                  label: '',
                ),
              ],
              onTap: onItemTapped,
              currentIndex: selectedIndex),
        ));
  }
}
