import 'dart:async';

import 'package:demo_profile_validations/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    Timer(
      const Duration(seconds: 2),
      () {
        Get.off(const ProfilePage());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Splash",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
