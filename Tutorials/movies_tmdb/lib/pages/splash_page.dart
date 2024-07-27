import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movies_tmdb/constants/color_constants.dart';
import 'package:movies_tmdb/constants/image_constants.dart';
import 'package:movies_tmdb/pages/home_page.dart';
import 'package:movies_tmdb/widgets/square_logo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const HomePage();
          }
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SquareLogo(
          elevation: 0,
          size: min(75.w, 75.h),
        ),
      ),
    );
  }
}
