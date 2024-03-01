import 'dart:io';

import 'package:chat_demo_for_swazz/common_widgets/common_filled_button.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SetupProfilePage extends ConsumerStatefulWidget {
  const SetupProfilePage({super.key});

  @override
  ConsumerState<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends ConsumerState<SetupProfilePage> {
  File? _pickedFile;
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
      maxWidth: double.infinity,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedFile = File(pickedImage.path);
    });
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
                      SizedBox(
                        width: 0.60.sw,
                        height: 0.60.sw,
                        child: ClipOval(
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {
                              _pickImage();
                            },
                            customBorder: const CircleBorder(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_pickedFile != null) ...[
                                  Image.file(_pickedFile!)
                                ] else ...[
                                  Container(
                                    color: Colors.white.withOpacity(0.25),
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Icon(
                                      FontAwesomeIcons.user,
                                      size: 0.25.sw,
                                    ),
                                  ),
                                ],
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.50),
                                    padding:
                                        EdgeInsets.only(top: 12.r, bottom: 8.r),
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
                              ],
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
                                  return "Please enter your First Name";
                                } else if (firstNameController.text.length <
                                    3) {
                                  return "Minimum 3 characters required";
                                }
                                return null;
                              },
                              controller: firstNameController,
                              labelText: "First Name",
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
                                  return "Please enter your Last Name";
                                } else if (lastNameController.text.length < 3) {
                                  return "Minimum 3 characters required";
                                }
                                return null;
                              },
                              controller: lastNameController,
                              labelText: "Last Name",
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
                        height: 0.1.sh,
                      ),
                      CommonFilledButton(
                        isFullWidth: false,
                        onPressed: () {
                          if (_pickedFile == null) {
                            Fluttertoast.showToast(
                                msg: "please click an image");
                          } else {
                            if ((formKey.currentState != null) &&
                                formKey.currentState!.validate()) {
                              Get.back(result: {
                                "profile_image": _pickedFile,
                                "display_name":
                                    "${firstNameController.text} ${lastNameController.text}"
                              });
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
