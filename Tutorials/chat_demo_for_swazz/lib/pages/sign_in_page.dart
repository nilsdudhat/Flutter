import 'dart:developer';

import 'package:chat_demo_for_swazz/common_widgets/common_filled_button.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_text_field.dart';
import 'package:chat_demo_for_swazz/pages/home_page.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final phoneFieldController = TextEditingController();
  String countryCode = "+91";
  final formKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey();

  void openCountryCodePicker() {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      showPhoneCode: true,
      // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        setState(() {
          countryCode = "+${country.phoneCode}";
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.all(16.r),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    SizedBox(
                      height: 0.15.sh,
                      child: InkWell(
                        onTap: () {
                          if (FirebaseAuth.instance.currentUser != null) {
                            FirebaseAuth.instance.signOut().then((value) {
                              log("auth----- sign out successful");
                              log("auth----- current user ${FirebaseAuth.instance.currentUser}");
                            }).catchError((onError) {
                              log("auth----- sign out error: ${onError.toString()}");
                            });
                          }
                        },
                        child: Image.asset("assets/images/telephone.png"),
                      ),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    CommonTextField(
                      key: phoneKey,
                      validator: (value) {
                        if ((phoneFieldController.text.length != 10) ||
                            !GetUtils.isNumericOnly(
                                phoneFieldController.text.toString())) {
                          return "Please enter valid Phone Number";
                        }
                        return null;
                      },
                      controller: phoneFieldController,
                      labelText: "Phone Number",
                      hintText: "Ex. 96364465633",
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.number,
                      maxLength: 10,
                      borderRadius: 12,
                      unfocusedColor: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.25),
                      prefix: InkWell(
                        onTap: () {
                          openCountryCodePicker();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 12.r),
                            Text(countryCode,
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.white)),
                            SizedBox(width: 8.r),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    CommonFilledButton(
                      isFullWidth: true,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          FirebaseAuth.instance
                              .verifyPhoneNumber(
                            phoneNumber:
                                "$countryCode${phoneFieldController.text.toString()}",
                            timeout: const Duration(seconds: 60),
                            verificationCompleted: (phoneAuthCredential) {
                              FirebaseAuth.instance
                                  .signInWithCredential(phoneAuthCredential)
                                  .then((value) => {
                                        Get.to(const HomePage()),
                                      })
                                  .catchError(
                                (error) {
                                  log("auth---- credential error: ${error.toString()}");
                                },
                              );
                            },
                            verificationFailed: (error) {
                              log("auth---- error: ${error.message}");
                            },
                            codeSent:
                                (verificationId, forceResendingToken) async {
                              final otp = await dialogForOTP(verificationId);
                              print("auth---- opt: $otp");

                              if ((otp != null) && otp.isNotEmpty) {
                                final credential = PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: otp);

                                FirebaseAuth.instance
                                    .signInWithCredential(credential)
                                    .then((value) {
                                  log("auth---- user authentication successful");
                                  log("auth---- user: ${value.user}");
                                  log("auth---- user: ${value.additionalUserInfo.toString()}");
                                }).catchError((onError) {
                                  log("auth---- otp verification error: ${onError.toString()}");
                                });
                              }
                            },
                            codeAutoRetrievalTimeout: (verificationId) {},
                          )
                              .catchError(
                            (error) {
                              log("auth---- verify error: ${error.toString()}");
                            },
                          );
                        }
                      },
                      text: "Sign In",
                      radius: 12,
                    ),
                    SizedBox(
                      height: 0.1.sh,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> dialogForOTP(
    String verificationId,
  ) async {
    TextEditingController controller = TextEditingController();

    final otp = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Enter SMS Code"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: controller,
            ),
          ],
        ),
        actions: <Widget>[
          CommonFilledButton(
            isFullWidth: true,
            onPressed: () {
              Get.back(result: controller.text.toString());
            },
            text: "Verify",
          ),
        ],
      ),
    );

    return otp;
  }
}
