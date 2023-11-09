import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffece7d5),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            backgroundColor: Color(0xff08231A),
            iconSize: 40,
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
                  child: SvgPicture.asset('assets/icon-home.svg'),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: '',
                backgroundColor: Color(0xff08231A),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: '',
                backgroundColor: Color(0xff08231A),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: '',
                backgroundColor: Color(0xff08231A),
              ),
            ],
          ),
        ));
  }
}
