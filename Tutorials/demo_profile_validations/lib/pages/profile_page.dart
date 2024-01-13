import 'package:demo_profile_validations/pages/profile_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final fullNameTextController = TextEditingController();
  final userNameTextController = TextEditingController();
  final emailIdTextController = TextEditingController();

  int age = 20;
  String gender = "Male";
  bool isTerms = false;

  bool isFullNameValidated = true;
  bool isUserNameValidated = true;
  bool isEmailIdValidated = true;

  late final SharedPreferences preferences;

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Set Up Profile",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 18.sp,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    margin: EdgeInsets.only(top: 10.h, bottom: 5.h),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: InkWell(
                        onTap: () {
                          print("image clicked");
                        },
                        child: SvgPicture.asset(
                          "assets/images/ic_user.svg",
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                    top: 2.h,
                    bottom: 1.h,
                  ),
                  child: TextField(
                    controller: fullNameTextController,
                    onChanged: (value) {
                      if (!isFullNameValidated) {
                        setState(() {
                          isFullNameValidated = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        labelText: "Enter Full Name",
                        errorText: isFullNameValidated
                            ? null
                            : "Value can't be empty"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.h,
                  ),
                  child: TextField(
                    controller: userNameTextController,
                    onChanged: (value) {
                      if (!isUserNameValidated) {
                        setState(() {
                          isUserNameValidated = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        labelText: "Enter User Name",
                        errorText: isUserNameValidated
                            ? null
                            : "Value can't be empty"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.h,
                  ),
                  child: TextField(
                    controller: emailIdTextController,
                    onChanged: (value) {
                      if (!isEmailIdValidated) {
                        setState(() {
                          isEmailIdValidated = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        labelText: "Enter Email ID",
                        errorText:
                            isEmailIdValidated ? null : "Value can't be empty"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.h,
                  ),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        "Age: ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 1.w),
                          value: age.toString(),
                          items: <String>[
                            '20',
                            '21',
                            '22',
                            '23',
                            "24",
                            "25",
                            "26",
                            "27",
                            "28",
                            "29"
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              age = int.parse(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        "Gender: ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 1.w),
                          value: gender,
                          items: <String>['Male', 'Female', 'Other']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                CheckboxListTile(
                  value: isTerms,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text("Teams & Conditions"),
                  onChanged: (value) {
                    setState(() {
                      if (value == null) return;
                      isTerms = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10.h,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: (MediaQuery.of(context).viewInsets.bottom == 0.0)
                ? Container(
                    margin: EdgeInsets.all(16.sp),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.sp),
                      ),
                      onPressed: () {
                        if (fullNameTextController.text.isEmpty) {
                          setState(() {
                            isFullNameValidated = false;
                          });
                        } else if (userNameTextController.text.isEmpty) {
                          setState(() {
                            isUserNameValidated = false;
                          });
                        } else if (!GetUtils.isUsername(
                            userNameTextController.text.toString())) {
                          Get.snackbar(
                            "Username",
                            "Please check valid Username",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else if (emailIdTextController.text.isEmpty) {
                          setState(() {
                            isEmailIdValidated = false;
                          });
                        } else if (!GetUtils.isEmail(
                            emailIdTextController.text.toString())) {
                          Get.snackbar(
                            "Email ID",
                            "Please check valid Email ID",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else if (!isTerms) {
                          Get.snackbar(
                            "Terms & Conditions",
                            "Please check Terms & Condition",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          Get.snackbar(
                            "Validations",
                            "All Okay",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );

                          storeData();
                        }
                      },
                      child: Text(
                        "Submit",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  void storeData() async {

    await preferences.setString("fullName", fullNameTextController.text.toString());
    await preferences.setString("userName", userNameTextController.text.toString());
    await preferences.setString("emailId", emailIdTextController.text.toString());
    await preferences.setInt("age", age);
    await preferences.setString("gender", gender);

    Get.off(const ProfileDetailsPage());
  }

  void getData() async {
    preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey("fullName")) {
      fullNameTextController.text = preferences.getString("fullName")!;
    }
    if (preferences.containsKey("userName")) {
      userNameTextController.text = preferences.getString("userName")!;
    }
    if (preferences.containsKey("emailId")) {
      emailIdTextController.text = preferences.getString("emailId")!;
    }
    if (preferences.containsKey("age")) {
      age = preferences.getInt("age")!;
    }
    if (preferences.containsKey("gender")) {
      gender = preferences.getString("gender")!;
    }
  }
}
