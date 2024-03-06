import 'dart:io';

import 'package:chat_demo_for_swazz/common_widgets/common_circular_image.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_filled_button.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_text_field.dart';
import 'package:chat_demo_for_swazz/providers/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../dialogs/edit_profile_image_dialog.dart';

class SetupProfilePage extends ConsumerStatefulWidget {
  const SetupProfilePage({super.key});

  @override
  ConsumerState<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends ConsumerState<SetupProfilePage> {
  File? _pickedFile;
  String? photoURL;
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final descriptionController = TextEditingController();

  void _pickImage() async {
    final selectionResult = await ImagePickerSelectionDialog.showDialog(
      context: context,
    );

    if (selectionResult != null) {
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

      if (pickedFile == null) {
        return;
      }

      setState(() {
        photoURL = null;
        _pickedFile = File(pickedFile!.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final firebaseAuthReadProvider = ref.read(firebaseAuthProvider);

    firebaseAuthReadProvider.getProfileDataFromFirestore(
      loadingStatus: (loadingStatus) {},
      onError: (error) {},
      onSuccess: (userDataMap) {
        if (userDataMap == null) {
          return;
        }
        String? displayName = userDataMap["userName"];
        if (displayName != null) {
          if (displayName.contains(" ")) {
            final split = displayName.split(" ");

            firstNameController.text = split[0];
            lastNameController.text = split[1];
          } else {
            firstNameController.text = displayName;
          }
        }
        String? description = userDataMap["description"];
        if (description != null) {
          descriptionController.text = description;
        }
        String? photo = userDataMap["profileImage"];
        if (photo != null) {
          photoURL = photo;
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (_pickedFile == null) {
          Fluttertoast.showToast(msg: "Profile Image is mandatory");
        } else {
          formKey.currentState!.validate();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(16.r),
            child: Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonCircularImage(
                        onImageClicked: () {
                          _pickImage();
                        },
                        size: 0.50.sw,
                        photoURL: photoURL,
                        file: _pickedFile,
                        iconData: FontAwesomeIcons.user,
                        editWidget: Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.50),
                            padding: EdgeInsets.only(top: 12.r, bottom: 8.r),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.05.sh,
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: CommonTextField(
                              validator: (value) {
                                if (firstNameController.text.isEmpty) {
                                  return "Enter First Name";
                                } else if (firstNameController.text.length <
                                    3) {
                                  return "Minimum 3 characters required";
                                }
                                return null;
                              },
                              controller: firstNameController,
                              labelText: "First Name *",
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.name,
                              borderRadius: 12,
                              maxLength: 20,
                              unfocusedColor: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.25),
                            ),
                          ),
                          SizedBox(
                            width: 0.05.sw,
                          ),
                          Flexible(
                            flex: 1,
                            child: CommonTextField(
                              validator: (value) {
                                if (lastNameController.text.isEmpty) {
                                  return "Enter Last Name";
                                } else if (lastNameController.text.length < 3) {
                                  return "Minimum 3 characters required";
                                }
                                return null;
                              },
                              controller: lastNameController,
                              labelText: "Last Name *",
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.name,
                              maxLength: 20,
                              borderRadius: 12,
                              unfocusedColor: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.25),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.05.sh,
                      ),
                      CommonTextField(
                        controller: descriptionController,
                        labelText: "Description",
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.name,
                        borderRadius: 12,
                        unfocusedColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.25),
                      ),
                      SizedBox(
                        height: 0.08.sh,
                      ),
                      CommonFilledButton(
                        isFullWidth: false,
                        onPressed: () {
                          if ((photoURL == null) && (_pickedFile == null)) {
                            Fluttertoast.showToast(
                                msg: "please click an image");
                          } else {
                            if ((formKey.currentState != null) &&
                                formKey.currentState!.validate()) {
                              Map<String, dynamic> params = {};
                              params["userName"] =
                                  "${firstNameController.text} ${lastNameController.text}";
                              params["description"] =
                                  descriptionController.text;
                              if (_pickedFile != null) {
                                params["profileImage"] = _pickedFile;
                              }

                              Get.back(result: params);
                            }
                          }
                        },
                        text: "Set Profile Image",
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
