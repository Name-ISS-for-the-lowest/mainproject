import 'package:flutter/material.dart';

class ResourceCenter extends StatefulWidget {
  const ResourceCenter({super.key});

  @override
  State<ResourceCenter> createState() => _ResourceCenterState();
}

class _ResourceCenterState extends State<ResourceCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffece7d5),
      body: Center(child: Text("Resource Center")),
    );
  }
}
