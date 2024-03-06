import 'package:chat_demo_for_swazz/common_widgets/common_filled_button.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    Widget widget = Container(
      padding: EdgeInsets.all(16.r),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(
            height: 0.02.sh,
          ),
          Text(message),
          SizedBox(
            height: 0.04.sh,
          ),
          if (highlight == Highlight.cancel) ...[
            Row(
              children: [
                Expanded(
                  child: CommonFilledButton(
                    isFullWidth: true,
                    onPressed: onCancelPressed,
                    text: cancelText,
                  ),
                ),
                SizedBox(
                  width: 0.05.sw,
                ),
                Expanded(
                  child: CommonOutlinedButton.text(
                    isFullWidth: true,
                    onPressed: onOkayPressed,
                    text: okayText,
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: CommonOutlinedButton.text(
                    isFullWidth: true,
                    onPressed: onCancelPressed,
                    text: cancelText,
                  ),
                ),
                SizedBox(
                  width: 0.05.sw,
                ),
                Expanded(
                  child: CommonFilledButton(
                    isFullWidth: true,
                    onPressed: onOkayPressed,
                    text: okayText,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );

    // show the dialog
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: cancelOnOutside,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
          },
          child: widget,
        );
      },
    );
  }

  static void hideConfirmationDialog() {
    /*if (!isVisible) {
      return;
    }
    isVisible = false;*/

    Get.back();
  }
}
