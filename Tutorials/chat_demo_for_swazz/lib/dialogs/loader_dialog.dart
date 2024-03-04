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
      useRootNavigator: true,
      builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
          },
          child: const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  static void hideLoader() {
    if (!isVisible) {
      return;
    }
    isVisible = false;

    Get.back();
  }
}
