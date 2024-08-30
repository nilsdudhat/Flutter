import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hivedatabase_flutter/pages/students_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const StudentsPage();
              },
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Splash"),
      ),
    );
  }
}
