import 'dart:io';

import 'package:chat_demo_for_swazz/common_widgets/common_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

enum ImagePickerType { camera, gallery }

class ImagePickerSelectionDialog {
  static Future<dynamic>? showDialog({
    required BuildContext context,
  }) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.r),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back(result: ImagePickerType.camera);
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          FontAwesomeIcons.camera,
                        ),
                        SizedBox(
                          height: 4.r,
                        ),
                        const Text("Camera")
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back(result: ImagePickerType.gallery);
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          FontAwesomeIcons.photoFilm,
                        ),
                        SizedBox(
                          height: 4.r,
                        ),
                        const Text("Gallery")
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    return result;
  }
}

class ConfirmProfileImageDialog {
  static Future<dynamic> showDialog({
    required BuildContext context,
    required File file,
  }) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.r),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipOval(
                    child: Image.file(file),
                  ),
                ),
              ),
              SizedBox(
                width: 0.05.sw,
              ),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Image Path: ${file.path}"),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    CommonFilledButton(
                        isFullWidth: true,
                        onPressed: () {
                          Get.back(result: "Upload");
                        },
                        text: "Confirm Upload")
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    return result;
  }
}
