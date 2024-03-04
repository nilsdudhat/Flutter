import 'dart:developer';
import 'dart:io';

import 'package:chat_demo_for_swazz/common_widgets/common_filled_button.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_outlined_button.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_text_field.dart';
import 'package:chat_demo_for_swazz/pages/home_page.dart';
import 'package:chat_demo_for_swazz/pages/setup_profile_page.dart';
import 'package:chat_demo_for_swazz/pages/verify_otp_page.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../dialogs/loader_dialog.dart';
import '../enums/loading_status.dart';
import '../providers/firebase_auth_provider.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final phoneFieldController = TextEditingController();
  String countryCode = "+91";
  final formKey = GlobalKey<FormState>();

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

  void setupProfile() async {
    final profileData = await Get.to(() => const SetupProfilePage());

    if (profileData != null) {
      Map<String, dynamic> profileMap = profileData as Map<String, dynamic>;

      File file = profileMap["profile_image"];
      String displayName = profileMap["display_name"];
      String? description = profileMap["description"];

      ref.read(firebaseAuthProvider).uploadProfileImage(
            file: file,
            loadingStatus: (loadingStatus) {
              setState(() {
                if (loadingStatus == LoadingStatus.loading) {
                  LoadingDialog.showLoader(context: context);
                } else {
                  LoadingDialog.hideLoader();
                }
              });
            },
            onError: (error) {
              Fluttertoast.showToast(msg: "Error: ${error.toString()}");
            },
            onSuccess: (String imageUrl) {
              registerUserWithFirestore(
                profileImageUrl: imageUrl,
                displayName: displayName,
                description: description,
              );
            },
          );
    }
  }

  void registerUserWithFirestore({
    required String profileImageUrl,
    required String displayName,
    required String? description,
  }) {
    ref.read(firebaseAuthProvider).registerUserWithFirestore(
          profileImage: profileImageUrl,
          displayName: displayName,
          description: description,
          loadingStatus: (LoadingStatus loadingStatus) {
            setState(() {
              if (loadingStatus == LoadingStatus.loading) {
                LoadingDialog.showLoader(context: context);
              } else {
                LoadingDialog.hideLoader();
              }
            });
          },
          onError: (String error) {
            Fluttertoast.showToast(msg: "Error: ${error.toString()}");
          },
          onSuccess: () {
            Get.offAll(() => const HomePage());
          },
        );
  }

  void signInWithGoogle() {
    ref.read(firebaseAuthProvider).getGoogleAuthCredential(
      loadingStatus: (LoadingStatus loadingStatus) {
        setState(() {
          if (loadingStatus == LoadingStatus.loading) {
            LoadingDialog.showLoader(context: context);
          } else {
            LoadingDialog.hideLoader();
          }
        });
      },
      onError: (String error) {
        log("google---- error: $error");
        Fluttertoast.showToast(msg: "Error: $error");
      },
      onSuccess: (OAuthCredential authCredential) {
        signInWithGoogleAuthCredential(authCredential: authCredential);
      },
    );
  }

  void signInWithGoogleAuthCredential({
    required OAuthCredential authCredential,
  }) {
    ref.read(firebaseAuthProvider).signInWithGoogleAuthCredential(
          credential: authCredential,
          loadingStatus: (LoadingStatus loadingStatus) {
            if (loadingStatus == LoadingStatus.loading) {
              LoadingDialog.showLoader(context: context);
            } else {
              LoadingDialog.hideLoader();
            }
          },
          onSuccessfulSignIn: (UserCredential userCredential) {
            log("google---- success: ${userCredential.toString()}");
            log("user--- ${userCredential.user?.displayName}");
            log("user--- ${userCredential.user?.phoneNumber}");
            log("user--- ${userCredential.user?.email}");
            log("user--- ${userCredential.user?.photoURL}");
            log("user--- ${DateTime.now().microsecondsSinceEpoch.toString()}");

            setupProfile();
          },
          onError: (String error) {
            log("google---- error: $error");
            Fluttertoast.showToast(msg: "Error: $error");
          },
        );
  }

  void uploadUserProfileImageIfNotAvailable() async {
    if (await ref.read(firebaseAuthProvider).needToUpdateProfile()) {
      setupProfile();
    }
  }

  @override
  void initState() {
    super.initState();

    uploadUserProfileImageIfNotAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
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
                        child: Image.asset("assets/images/telephone.png"),
                      ),
                      SizedBox(
                        height: 0.05.sh,
                      ),
                      CommonTextField(
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
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            FocusScope.of(context).requestFocus(FocusNode());

                            await Get.to(
                              () => VerifyOTPPage(
                                phoneNumber:
                                    "$countryCode${phoneFieldController.text.toString()}",
                                isRegister: true,
                              ),
                            );

                            if (context.mounted) {
                              LoadingDialog.showLoader(context: context);
                            }
                            if (await ref
                                .read(firebaseAuthProvider)
                                .needToUpdateProfile()) {
                              LoadingDialog.hideLoader();

                              Get.offAll(() => const HomePage());
                            } else {
                              LoadingDialog.hideLoader();

                              setupProfile();
                            }
                          }
                        },
                        text: "Sign In",
                        radius: 12,
                      ),
                      SizedBox(
                        height: 0.2.sh,
                      ),
                      CommonOutlinedButton.child(
                        isFullWidth: true,
                        onPressed: () async {
                          signInWithGoogle();
                        },
                        borderColor: Colors.white,
                        splashColor: Theme.of(context).colorScheme.primary,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/google.png",
                              width: 18.w,
                              height: 18.w,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
