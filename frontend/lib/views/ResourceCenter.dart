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
              width: 75,
              height: 75,
              child: SvgPicture.asset('assets/ResourceCenter/icon-homehome.svg'),
            ),
            Spacer(),
            SizedBox(
            width: 75,
            height: 75,
            child: SvgPicture.asset("assets/ResourceCenter/icon-visavisa.svg"),
            ),
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/ResourceCenter/icon-jobjob.svg"),
            width: 75,
            height: 75,
            ),
            Spacer(),
          ],
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/ResourceCenter/icon-research.svg"),
            width: 75,
            height: 75,
            ),
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/ResourceCenter/icon-earthearth.svg"),
            width: 75,
            height: 75,
            ),
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/ResourceCenter/icon-serna.svg"),
            width: 75,
            height: 75,
            ),
            Spacer(),
          ],
        ),
        Spacer(),Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/ResourceCenter/icon-research.svg"),
            width: 75,
            height: 75,
            ),
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/ResourceCenter/icon-earthearth.svg"),
            width: 75,
            height: 75,
            ),
            Spacer(),
            SizedBox(
            child: SvgPicture.asset("assets/ResourceCenter/icon-serna.svg"),
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
