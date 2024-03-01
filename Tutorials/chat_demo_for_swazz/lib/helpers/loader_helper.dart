import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDialog {
  static bool isVisible = false;

  static void showLoader({required BuildContext context}) {
    if (isVisible) {
      return;
    }
    isVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) {
        return const CircularProgressIndicator(
          color: Colors.white,
        );
      },
    );
  }

  static void hideLoader() {
    if (!isVisible) {
      return;
    }

    Get.back();
  }
}
