import 'package:demo_profile_validations/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  @override
  void initState() {
    super.initState();

    getData();
  }

  String? fullName;
  String? userName;
  String? emailId;
  int? age;
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          (fullName != null) ? fullName! : "",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 18.sp,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          print("pressed floating");
          Get.off(const ProfilePage());
        },
      ),
      body: Column(
        children: [
          if (fullName != null)
            Container(
              margin: EdgeInsets.only(
                left: 5.w,
                right: 5.w,
                top: 2.h,
                bottom: 1.h,
              ),
              child: Row(
                children: [
                  Text(
                    "Full Name : ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    fullName!,
                  ),
                ],
              ),
            ),
          if (userName != null)
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 1.h,
              ),
              child: Row(
                children: [
                  Text(
                    "User Name : ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    userName!,
                  ),
                ],
              ),
            ),
          if (emailId != null)
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 1.h,
              ),
              child: Row(
                children: [
                  Text(
                    "Email ID : ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    emailId!,
                  ),
                ],
              ),
            ),
          if (age != null)
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 1.h,
              ),
              child: Row(
                children: [
                  Text(
                    "Age : ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    age!.toString(),
                  ),
                ],
              ),
            ),
          if (gender != null)
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 1.h,
              ),
              child: Row(
                children: [
                  Text(
                    "Gender : ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    gender!,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void getData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      fullName = preferences.getString("fullName");
      userName = preferences.getString("userName");
      emailId = preferences.getString("emailId");
      age = preferences.getInt("age");
      gender = preferences.getString("gender");
    });
  }
}
