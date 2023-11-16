import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResourceCenter extends StatefulWidget {
  const ResourceCenter({super.key});

  @override
  State<ResourceCenter> createState() => _ResourceCenterState();
}

class _ResourceCenterState extends State<ResourceCenter> {
  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffece7d5),
      body: Center(child: Text("Resource Center")),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Student Resources", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/icon-homehome.svg"),
            width: 75,
            height: 75,
            ),
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/icon-visavisa.svg"),
            width: 75,
            height: 75,
            ),
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/icon-jobjob.svg"),
            width: 75,
            height: 75,
            ),
            Spacer(),
          ],
        ),
        Spacer(),
      ]
    );
  }
  
}
