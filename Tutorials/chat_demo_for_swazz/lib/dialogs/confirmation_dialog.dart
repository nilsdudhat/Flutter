import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Highlight {
  okay,
  cancel,
}

class ConfirmationDialog {
  static bool isVisible = false;

  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String cancelText,
    required String okayText,
    required bool cancelOnOutside,
    required Highlight highlight,
    required Function() onCancelPressed,
    required Function() onOkayPressed,
  }) {
    /*if (isVisible) {
      return;
    }
    isVisible = true;*/

    TextStyle highlightStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    TextStyle style = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w400,
    );

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        cancelText,
        style: (Highlight.cancel == highlight) ? highlightStyle : style,
      ),
      onPressed: () {
        hideConfirmationDialog();

        onCancelPressed.call();
      },
    );
    Widget okayButton = TextButton(
      child: Text(
        okayText,
        style: (Highlight.okay == highlight) ? highlightStyle : style,
      ),
      onPressed: () {
        hideConfirmationDialog();

        onOkayPressed.call();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(message),
      actions: [
        cancelButton,
        okayButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: cancelOnOutside,
      builder: (BuildContext context) {
        return PopScope(
          canPop: cancelOnOutside,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
          },
          child: alert,
        );
      },
    );
  }

  static void hideConfirmationDialog() {
    if (!isVisible) {
      return;
    }
    isVisible = false;

    Get.back();
  }
}
