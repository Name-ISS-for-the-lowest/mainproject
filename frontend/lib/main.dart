import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent
      statusBarIconBrightness:
          Brightness.dark, // Use dark icons for better visibility
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false, //remove debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromRGBO(4, 57, 39, 1)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromRGBO(4, 57, 39, 1),
      ),
      home: const Home(),
    );
  }
}
