import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceCenter extends StatefulWidget {
  const ResourceCenter({super.key});

  @override
  State<ResourceCenter> createState() => _ResourceCenterState();
}

class _ResourceCenterState extends State<ResourceCenter> {
  Future<void> _launchURL(Uri url) async {  
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Color(0x0008231A)
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text("Housing", style: TextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {
                      _launchURL(Uri.parse("https://www.csus.edu/international-programs-global-engagement/international-student-scholar-services/housing.html"));}, 
                    icon: SvgPicture.asset("assets/ResourceCenter/icon-homehome.svg"),
                    color: Colors.white,
                  ),
                ]
              ),
            ),
            Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Color(0x0008231A)
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text("F1/J1 Status", style: TextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {_launchURL(Uri.parse("https://www.csus.edu/international-programs-global-engagement/international-student-scholar-services/maintaining-status.html")); }, 
                    icon: SvgPicture.asset("assets/ResourceCenter/icon-visavisa.svg"),
                    color: Colors.white,
                  ),
                ]
              ),
            ),
            Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Color(0x0008231A)
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text("F1/J1 Jobs", style: TextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {_launchURL(Uri.parse("https://www.csus.edu/international-programs-global-engagement/international-student-scholar-services/employment.html")); }, 
                    icon: SvgPicture.asset("assets/ResourceCenter/icon-jobjob.svg"),
                    color: Colors.white,
                  ),
                ]
              ),
            ),
            Spacer(),
          ],
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Color(0x0008231A)
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text("Research", style: TextStyle(color: Colors.white)),
                  Text("Scholar", style: TextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {_launchURL(Uri.parse("https://www.csus.edu/international-programs-global-engagement/international-student-scholar-services/international-visiting-research-scholars.html")); }, 
                    icon: SvgPicture.asset("assets/ResourceCenter/icon-research.svg"),
                    color: Colors.white,
                  ),
                ]
              ),
            ),
            /*SizedBox(
            child: SvgPicture.asset("assets/ResourceCenter/icon-research.svg"),
            width: 75,
            height: 75,
            ),*/
            Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Color(0x0008231A)
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text("Multicultural", style: TextStyle(color: Colors.white)),
                  Text("Center", style: TextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {_launchURL(Uri.parse("https://www.csus.edu/student-affairs/centers-programs/multi-cultural-center/")); }, 
                    icon: SvgPicture.asset("assets/ResourceCenter/icon-earthearth.svg"),
                    color: Colors.white,
                  ),
                ]
              ),
            ),
            Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Color(0x0008231A)
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text("Serna Center", style: TextStyle(color: Colors.white)),
                  Spacer(),
                  IconButton(
                    onPressed: () {_launchURL(Uri.parse("https://www.csus.edu/student-affairs/centers-programs/serna-center/")); }, 
                    icon: SvgPicture.asset("assets/ResourceCenter/icon-serna.svg"),
                    color: Colors.white,
                  ),
                  Spacer(),
                ]
              ),
            ),
            Spacer(),
          ],
        ),
        Spacer(),Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Color(0x0008231A)
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text("APIDA", style: TextStyle(color: Colors.white)),
                  Text("Center", style: TextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {_launchURL(Uri.parse("https://www.csus.edu/student-affairs/centers-programs/asian-pacific-islander-desi-american-student-center/"));}, 
                    icon: SvgPicture.asset("assets/ResourceCenter/icon-serna.svg"),
                    color: Colors.white,
                  ),
                ]
              ),
            ),
            Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Color(0x0008231A)
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text("Health and", style: TextStyle(color: Colors.white)),
                  Text("Counseling", style: TextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {_launchURL(Uri.parse("https://www.csus.edu/student-life/health-counseling/"));}, 
                    icon: SvgPicture.asset("assets/ResourceCenter/icon-heart.svg"),
                    color: Colors.white,
                  ),
                ]
              ),
            ),
            Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Color(0x0008231A)
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text("Basic Needs", style: TextStyle(color: Colors.white)),
                  Spacer(),
                  IconButton(
                    onPressed: () {_launchURL(Uri.parse("https://www.csus.edu/student-affairs/crisis-assistance-resource-education-support/resources.html"));}, 
                    icon: SvgPicture.asset("assets/ResourceCenter/icon-basic.svg"),
                    color: Colors.white,
                  ),
                  Spacer(),
                ]
              ),
            ),
            Spacer(),
          ],
        ),
        Spacer(),
      ]
    );
  }
  
}
