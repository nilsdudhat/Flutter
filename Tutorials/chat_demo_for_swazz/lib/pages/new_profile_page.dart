import 'dart:developer';
import 'dart:io';

import 'package:chat_demo_for_swazz/dialogs/edit_profile_image_dialog.dart';
import 'package:chat_demo_for_swazz/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../common_widgets/common_circular_image.dart';
import '../dialogs/confirmation_dialog.dart';
import '../dialogs/loader_dialog.dart';
import '../enums/loading_status.dart';
import '../providers/firebase_auth_provider.dart';
import '../utils/screen_utils.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? photoURL = "";
  String? description = "";
  String? email = "";
  String? userName = "";
  String? phoneNumber = "";

  File? photoFile;

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
            log("auth----- current user ${ref.read(firebaseAuthProvider)}");

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

  void editProfileImage() async {
    final selectionResult = await ImagePickerSelectionDialog.showDialog(
      context: context,
    );

    if (selectionResult != null) {
      log("--image-- selection type: $selectionResult");

      File? pickedFile;

      if (selectionResult == ImagePickerType.camera) {
        final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 75,
          maxWidth: double.infinity,
        );

        if (pickedImage == null) {
          return;
        }

        pickedFile = File(pickedImage.path);
      }

      if (selectionResult == ImagePickerType.gallery) {
        final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 75,
          maxWidth: double.infinity,
        );

        if (pickedImage == null) {
          return;
        }

        pickedFile = File(pickedImage.path);
      }

      if (pickedFile != null) {
        log("--image-- ${pickedFile.path}");

        if (context.mounted) {
          final confirmResult = await ConfirmProfileImageDialog.showDialog(
              context: context, file: pickedFile);

          if (confirmResult != null) {
            ref.read(firebaseAuthProvider).uploadProfileImage(
              file: pickedFile,
              loadingStatus: (loadingStatus) {
                if (loadingStatus == LoadingStatus.loading) {
                  LoadingDialog.showLoader(context: context);
                } else {
                  LoadingDialog.hideLoader();
                }
              },
              onError: (error) {
                log("--image-- error: $error");
                Fluttertoast.showToast(msg: "Error: $error");
              },
              onSuccess: (imageUrl) {
                setState(() {
                  photoURL = imageUrl;
                });
              },
            );
          }
        }
      }
    }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        CommonCircularImage(
                          size: 0.40.sw,
                          photoURL: photoURL,
                          file: null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              editProfileImage();
                            },
                            child: ClipOval(
                              child: Container(
                                color: Theme.of(context).colorScheme.primary,
                                padding: EdgeInsets.all(10.r),
                                child: Icon(
                                  Icons.edit,
                                  size: 0.06.sw,
                                ),
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
    );
  }
}
