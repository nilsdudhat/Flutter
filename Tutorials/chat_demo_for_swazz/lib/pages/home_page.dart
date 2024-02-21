import 'dart:developer';

import 'package:chat_demo_for_swazz/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  if (ref
                      .read(firebaseAuthProvider)
                      .isUserLoggedIn()) {
                    ref
                        .read(firebaseAuthProvider)
                        .signOut()
                        .then((value) {
                      log("auth----- sign out successful");
                      log("auth----- current user ${FirebaseAuth.instance.currentUser}");

                      Get.off(const SignInPage());
                    }).catchError((onError) {
                      log("auth----- sign out error: ${onError.toString()}");
                    });
                  } else {
                    log("auth----- sign in required to sign out");
                  }
                },
                borderRadius: BorderRadius.circular(45),
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: const Icon(Icons.logout),
                ),
              ),
            ),
            const Center(
              child: Text(
                "Home Page",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
