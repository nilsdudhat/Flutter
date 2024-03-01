import 'dart:async';

import 'package:chat_demo_for_swazz/pages/setup_profile_page.dart';
import 'package:chat_demo_for_swazz/pages/sign_in_page.dart';
import 'package:chat_demo_for_swazz/providers/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'home_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () async {
        if (ref.read(firebaseProvider).isUserLoggedIn()) {
          if (ref.read(firebaseProvider).isUserLoggedIn() &&
              !(await ref
                  .read(firebaseProvider)
                  .isUserExistInFirestore())) {
            Get.off(() => const SignInPage());
          } else {
            Get.off(() => const HomePage());
          }
        } else {
          Get.off(() => const SignInPage());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Splash Page',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
