import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';

class ConfirmReport extends StatefulWidget {
  const ConfirmReport({super.key});

  @override
  State<ConfirmReport> createState() => _ConfirmReportState();
}

class _ConfirmReportState extends State<ConfirmReport> {
  void navigateToPrimaryScreens() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffece7d5),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: GestureDetector(
            child: const Icon(
              Icons.close,
              color: Colors.black,
              size: 30,
            ),
            onTap: () => navigateToPrimaryScreens(),
          ),
          title: Text(
            Localize("Report Post"),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              height: 1.0, // Set the desired height of the line
              color: const Color(0x5f000000),
            ),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Localize(
                      "We have received your report, thank you for submitting it."),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  Localize(
                      "User experience is what we value most at International Student Station and your input is very valuable to us."),
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  Localize(
                      "We will be reviewing your report soon, please click the button below or the close button on your top left to return to the app."),
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    navigateToPrimaryScreens();
                  },
                  child: Text(
                    Localize("Take me Back"),
                    style: const TextStyle(
                      color: Color(0xff007EF1),
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
