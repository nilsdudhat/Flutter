import 'package:flutter/material.dart';

class ScreenHelper {
  static bool isKeyboardVisible({required BuildContext context}) {
    return MediaQuery.of(context).viewInsets.bottom > 0.0;
  }
}
