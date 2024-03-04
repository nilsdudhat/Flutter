import 'package:flutter/material.dart';

class ScreenUtils {
  static bool isKeyboardVisible({required BuildContext context}) {
    return MediaQuery.of(context).viewInsets.bottom > 0.0;
  }
}
