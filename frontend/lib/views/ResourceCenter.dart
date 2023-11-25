import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/classes/authHelper.dart';

class ResourceCenter extends StatefulWidget {
  const ResourceCenter({super.key});

  @override
  State<ResourceCenter> createState() => _ResourceCenterState();
}

class _ResourceCenterState extends State<ResourceCenter> {
  final double width = 110;
  final double height = 110;

  final iconSize = 20.0;

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _IconBuilder(String text, String iconPath, String url) {
    return GestureDetector(
      onTap: () {
        _launchURL(Uri.parse(url));
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: const Color(0x0008231A)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 38,
                width: 100,
                child: Text(
                    textAlign: TextAlign.center,
                    text,
                    style: const TextStyle(color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset(
                      iconPath,
                      semanticsLabel: text,
                      color: Colors.white,
                    )),
              )
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userLang = AuthHelper.userInfoCache['language'];
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Localize("Student Resources"),
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _IconBuilder(
                  Localize("Housing"),
                  "assets/ResourceCenter/icon-homehome.svg",
                  "https://www-csus-edu.translate.goog/international-programs-global-engagement/international-student-scholar-services/housing.html?_x_tr_sl=auto&_x_tr_tl=${userLang}&_x_tr_hl=en&_x_tr_pto=wapp"),
              const Spacer(),
              _IconBuilder(
                Localize("F1/J1 Status"),
                "assets/ResourceCenter/icon-visavisa.svg",
                "https://www-csus-edu.translate.goog/international-programs-global-engagement/international-student-scholar-services/maintaining-status.html?_x_tr_sl=auto&_x_tr_tl=${userLang}&_x_tr_hl=en&_x_tr_pto=wapp",
              ),
              const Spacer(),
              _IconBuilder(
                Localize("F1/J1 Jobs"),
                "assets/ResourceCenter/icon-jobjob.svg",
                "https://www-csus-edu.translate.goog/international-programs-global-engagement/international-student-scholar-services/employment.html?_x_tr_sl=auto&_x_tr_tl=${userLang}&_x_tr_hl=en&_x_tr_pto=wapp",
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _IconBuilder(
                Localize("Research Scholar"),
                "assets/ResourceCenter/icon-research.svg",
                "https://www-csus-edu.translate.goog/international-programs-global-engagement/international-student-scholar-services/international-visiting-research-scholars.html?_x_tr_sl=auto&_x_tr_tl=${userLang}&_x_tr_hl=en&_x_tr_pto=wapp",
              ),
              const Spacer(),
              _IconBuilder(
                Localize("Multicultural Center"),
                "assets/ResourceCenter/icon-globeoutline.svg",
                "https://www-csus-edu.translate.goog/student-affairs/centers-programs/multi-cultural-center/?_x_tr_sl=auto&_x_tr_tl=${userLang}&_x_tr_hl=en&_x_tr_pto=wapp",
              ),
              const Spacer(),
              _IconBuilder(
                Localize("Serna Center"),
                "assets/ResourceCenter/icon-americas.svg",
                "https://www-csus-edu.translate.goog/student-affairs/centers-programs/serna-center/?_x_tr_sl=auto&_x_tr_tl=${userLang}&_x_tr_hl=en&_x_tr_pto=wapp",
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _IconBuilder(
                Localize("APIDA Center"),
                "assets/ResourceCenter/icon-australasia.svg",
                "https://www-csus-edu.translate.goog/student-affairs/centers-programs/asian-pacific-islander-desi-american-student-center/?_x_tr_sl=auto&_x_tr_tl=${userLang}&_x_tr_hl=en&_x_tr_pto=wapp",
              ),
              const Spacer(),
              _IconBuilder(
                Localize("Health and Counseling"),
                "assets/ResourceCenter/icon-heart.svg",
                "https://www-csus-edu.translate.goog/student-life/health-counseling/?_x_tr_sl=auto&_x_tr_tl=${userLang}&_x_tr_hl=en&_x_tr_pto=wapp",
              ),
              const Spacer(),
              _IconBuilder(
                Localize("Basic Needs"),
                "assets/ResourceCenter/icon-basic.svg",
                "https://www-csus-edu.translate.goog/student-life/health-counseling/?_x_tr_sl=auto&_x_tr_tl=${userLang}&_x_tr_hl=en&_x_tr_pto=wapp",
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ]);
  }
}
