import 'dart:developer';

import 'package:chat_demo_for_swazz/common_widgets/common_circular_image.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_text_field.dart';
import 'package:chat_demo_for_swazz/dialogs/confirmation_dialog.dart';
import 'package:chat_demo_for_swazz/pages/sign_in_page.dart';
import 'package:chat_demo_for_swazz/pages/verify_otp_page.dart';
import 'package:chat_demo_for_swazz/providers/firebase_auth_provider.dart';
import 'package:chat_demo_for_swazz/utils/screen_utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../dialogs/loader_dialog.dart';
import '../enums/loading_status.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  String? photoURL = "";
  String? description = "";
  String? email = "";
  String? userName = "";
  String? phoneNumber = "";

  String countryCode = "+91";

  final phoneKey = GlobalKey<FormState>();
  final descriptionKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();

  void getProfileData() {
    LoadingDialog.showLoader(context: context);

    final firebaseAuthReadProvider = ref.read(firebaseAuthProvider);
    User user = firebaseAuthReadProvider.getUser();

    if ((user.email != null) && user.email!.isNotEmpty) {
      email = user.email!;
    }

    if ((user.displayName != null) && user.displayName!.isNotEmpty) {
      userName = user.displayName!;
    }

    if ((user.phoneNumber != null) && user.phoneNumber!.isNotEmpty) {
      phoneNumber = user.phoneNumber!;
    }

    if ((user.photoURL != null) && user.photoURL!.isNotEmpty) {
      photoURL = user.photoURL!;
    }

    setState(() {});

    firebaseAuthReadProvider.getProfileDataFromFirestore(
      loadingStatus: (loadingStatus) {},
      onError: (error) {},
      onSuccess: (userDataMap) {
        LoadingDialog.hideLoader();

        if (userDataMap == null) {
          return;
        }

        Map<String, dynamic> profileData = {};

        if (userDataMap.containsKey("emailID")) {
          if (email!.isEmpty) {
            email = userDataMap["emailID"];
          } else {
            if (email != userDataMap["emailID"]) {
              profileData["emailID"] = email;
            }
          }
        } else {
          if (email!.isNotEmpty) {
            profileData["emailID"] = email;
          }
        }
        if (userDataMap.containsKey("phoneNumber")) {
          if (phoneNumber!.isEmpty) {
            phoneNumber = userDataMap["phoneNumber"];
          } else {
            if (phoneNumber != userDataMap["phoneNumber"]) {
              profileData["phoneNumber"] = phoneNumber;
            }
          }
        } else {
          if (phoneNumber!.isNotEmpty) {
            profileData["phoneNumber"] = phoneNumber;
          }
        }
        if (userDataMap.containsKey("userName")) {
          if (userName!.isEmpty) {
            userName = userDataMap["userName"];
          } else {
            if (userName != userDataMap["userName"]) {
              profileData["userName"] = userName;
            }
          }
        } else {
          if (userName!.isNotEmpty) {
            profileData["userName"] = userName;
          }
        }
        if (userDataMap.containsKey("photoURL")) {
          if (photoURL!.isEmpty) {
            photoURL = userDataMap["photoURL"];
          } else {
            if (photoURL != userDataMap["photoURL"]) {
              profileData["photoURL"] = photoURL;
            }
          }
        } else {
          if (photoURL!.isNotEmpty) {
            profileData["photoURL"] = photoURL;
          }
        }
        if (userDataMap.containsKey("description")) {
          description = userDataMap["description"];
        }
        setState(() {});

        if (profileData.isNotEmpty) {
          firebaseAuthReadProvider.updateProfileData(
            params: profileData,
            loadingStatus: (LoadingStatus loadingStatus) {
              if (loadingStatus == LoadingStatus.loading) {
                LoadingDialog.showLoader(context: context);
              } else {
                LoadingDialog.hideLoader();
              }
            },
            onError: (String error) {
              Fluttertoast.showToast(msg: "Error: $error");
            },
            onSuccess: () {},
          );
        }
      },
    );
  }

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

  void updatePhoneNumber() {
    final firebaseAuthReadProvider = ref.read(firebaseAuthProvider);
    String? phoneNumber = firebaseAuthReadProvider.getUser().phoneNumber;

    if ((phoneNumber != null) && phoneNumber.isNotEmpty) {
      Map<String, dynamic> params = {"phoneNumber": phoneNumber};
      firebaseAuthReadProvider.updateProfileData(
        params: params,
        loadingStatus: (LoadingStatus loadingStatus) {
          if (loadingStatus == LoadingStatus.loading) {
            LoadingDialog.showLoader(context: context);
          } else {
            LoadingDialog.hideLoader();
          }
        },
        onError: (String error) {
          Fluttertoast.showToast(msg: "Error: $error");
        },
        onSuccess: () {
          getProfileData();
        },
      );
    }
  }

  void updateEmailID() async {
    try {
      final firebaseAuthReadProvider = ref.read(firebaseAuthProvider);
      String emailID = emailController.text;

      final isEmailAlreadyInUse = await firebaseAuthReadProvider
          .isEmailAlreadyInUse(enteredEmailID: emailID);

      if (!isEmailAlreadyInUse) {
        Map<String, dynamic> params = {
          "emailID": emailID,
        };
        firebaseAuthReadProvider.updateProfileData(
          params: params,
          loadingStatus: (LoadingStatus loadingStatus) {
            if (loadingStatus == LoadingStatus.loading) {
              LoadingDialog.showLoader(context: context);
            } else {
              LoadingDialog.hideLoader();
            }
          },
          onError: (String error) {
            Fluttertoast.showToast(msg: "Error: $error");
          },
          onSuccess: () {
            getProfileData();
          },
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Provided Email ID is already in use"),
            ),
          );
        }
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: $error");

      log("--error-- updateEmailID: ${error.toString()}");
    }
  }

  void updateDescription() {
    final firebaseAuthReadProvider = ref.read(firebaseAuthProvider);

    firebaseAuthReadProvider.updateProfileData(
      params: {
        "description": descriptionController.text,
      },
      loadingStatus: (loadingStatus) {
        if (loadingStatus == LoadingStatus.loading) {
          LoadingDialog.showLoader(context: context);
        } else {
          LoadingDialog.hideLoader();
        }
      },
      onError: (error) {
        Fluttertoast.showToast(msg: "Error: $error");
      },
      onSuccess: () {
        getProfileData();
      },
    );
  }

  void signOut() {
    ConfirmationDialog.showConfirmationDialog(
      context: context,
      title: "Sign Out",
      message: "Are you sure, you want to Sign Out?",
      cancelText: "Cancel",
      okayText: "Sign Out",
      cancelOnOutside: true,
      highlight: Highlight.cancel,
      onCancelPressed: () {
        ConfirmationDialog.hideConfirmationDialog();
      },
      onOkayPressed: () {
        if (ref.read(firebaseAuthProvider).isUserLoggedIn()) {
          ref.read(firebaseAuthProvider).signOut().then((value) {
            log("auth----- sign out successful");
            log("auth----- current user ${FirebaseAuth.instance.currentUser}");

            Get.offAll(() => const SignInPage());
          }).catchError((onError) {
            log("auth----- sign out error: ${onError.toString()}");
          });
        } else {
          log("auth----- sign in required to sign out");
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          if (ScreenUtils.isKeyboardVisible(context: context)) {
            FocusScope.of(context).requestFocus(FocusNode());
          } else {
            Get.back();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  signOut();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    Center(
                      child: CommonCircularImage(
                        size: 0.40.sw,
                        photoURL: photoURL,
                        file: null,
                      ),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.50),
                      ),
                    ),
                    Text(
                      userName!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if ((email != null) && email!.isNotEmpty) ...[
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Text(
                        "Email ID",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.50),
                        ),
                      ),
                      Text(
                        email!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    if ((phoneNumber != null) && phoneNumber!.isNotEmpty) ...[
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.50),
                        ),
                      ),
                      Text(
                        phoneNumber!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    if ((description != null) && description!.isNotEmpty) ...[
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.50),
                        ),
                      ),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    if ((email == null) && email!.isEmpty) ...[
                      SizedBox(
                        height: 0.04.sh,
                      ),
                      Form(
                        key: emailKey,
                        child: CommonTextField(
                          validator: (value) {
                            if (emailController.text.isEmpty ||
                                !GetUtils.isEmail(emailController.text)) {
                              return "Please enter valid Email ID";
                            }
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () {
                              if ((emailKey.currentState != null) &&
                                  emailKey.currentState!.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                updateEmailID();
                              }
                            },
                            icon: const Icon(
                              Icons.upload,
                              color: Colors.white,
                            ),
                          ),
                          controller: emailController,
                          labelText: "Email ID",
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.emailAddress,
                          borderRadius: 12,
                          unfocusedColor: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.25),
                        ),
                      ),
                    ],
                    if ((phoneNumber == null) || phoneNumber!.isEmpty) ...[
                      SizedBox(
                        height: 0.04.sh,
                      ),
                      Form(
                        key: phoneKey,
                        child: CommonTextField(
                          validator: (value) {
                            if ((phoneController.text.length != 10) ||
                                !GetUtils.isNumericOnly(
                                    phoneController.text.toString())) {
                              return "Please enter valid Phone Number";
                            }
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () async {
                              if ((phoneKey.currentState != null) &&
                                  phoneKey.currentState!.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                await Get.to(
                                  () => VerifyOTPPage(
                                    phoneNumber:
                                        "$countryCode${phoneController.text.toString()}",
                                    isRegister: false,
                                  ),
                                );
                                updatePhoneNumber();
                              }
                            },
                            icon: const Icon(
                              Icons.upload,
                              color: Colors.white,
                            ),
                          ),
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
                          controller: phoneController,
                          labelText: "Phone Number",
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.phone,
                          borderRadius: 12,
                          maxLength: 10,
                          unfocusedColor: Colors.white.withOpacity(0.25),
                        ),
                      ),
                    ],
                    if ((description == null) && description!.isEmpty) ...[
                      SizedBox(
                        height: 0.04.sh,
                      ),
                      Form(
                        key: descriptionKey,
                        child: CommonTextField(
                          validator: (value) {
                            if (descriptionController.text.isEmpty) {
                              return "Please enter something about yourself";
                            }
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () async {
                              if ((descriptionKey.currentState != null) &&
                                  descriptionKey.currentState!.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                updateDescription();
                              }
                            },
                            icon: const Icon(
                              Icons.upload,
                              color: Colors.white,
                            ),
                          ),
                          controller: descriptionController,
                          labelText: "Description",
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                          borderRadius: 12,
                          unfocusedColor: Colors.white.withOpacity(0.25),
                        ),
                      ),
                    ],
                    SizedBox(
                      height: 0.05.sh,
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
}
