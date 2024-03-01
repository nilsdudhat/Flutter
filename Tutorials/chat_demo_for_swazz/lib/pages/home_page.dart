import 'dart:developer';

import 'package:chat_demo_for_swazz/pages/profile_page.dart';
import 'package:chat_demo_for_swazz/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../providers/firebase_auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Swazz Chat",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const ProfilePage());
            },
            icon: Icon(
              FontAwesomeIcons.circleUser,
              size: 24.r,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          FontAwesomeIcons.plus,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  if (ref.read(firebaseProvider).isUserLoggedIn()) {
                    ref.read(firebaseProvider).signOut().then((value) {
                      log("auth----- sign out successful");
                      log("auth----- current user ${FirebaseAuth.instance.currentUser}");

                      Get.off(() => const SignInPage());
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
