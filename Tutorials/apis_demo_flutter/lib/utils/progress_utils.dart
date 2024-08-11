import 'package:flutter/material.dart';

class ProgressUtils {
  static BuildContext? dialogContext;

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        );
      },
    );
  }

  static void hide() {
    if (dialogContext == null) {
      return;
    }
    Navigator.pop(dialogContext!);
    dialogContext = null;
  }
}
