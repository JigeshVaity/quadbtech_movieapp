import 'package:flutter/material.dart';

import 'package:quadbtechapp/screen/Splash.dart';

import 'main.dart'; // Replace with your correct file path

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}


