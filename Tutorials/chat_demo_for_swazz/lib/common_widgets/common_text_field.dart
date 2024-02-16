import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    required this.controller,
    this.borderRadius,
    this.borderWidth,
    this.labelWeight,
    this.labelText,
    this.hintText,
    this.prefix,
    this.textInputType,
    this.unfocusedColor,
    this.focusedColor,
    this.maxLength,
    this.textInputAction,
  });

  final TextEditingController controller;

  /// default: 45
  final double? borderRadius;

  /// default: 1
  final double? borderWidth;

  /// default: FontWeight.w600
  final FontWeight? labelWeight;

  /// default: null
  final String? labelText;

  /// default: null
  final String? hintText;

  /// default: null
  /// to display widget ahead of the input field
  final Widget? prefix;

  /// default: TextInputType.text
  /// to open up specific type of keyboard as per requirement of the feature - e.g. email, phone, number
  final TextInputType? textInputType;

  /// default: Theme.of(context).colorScheme.background.withOpacity(0.25)
  /// color of border and hint while field is not focussed
  final Color? unfocusedColor;

  /// default: Theme.of(context).colorScheme.primary
  /// color of border and hint while field is focussed
  final Color? focusedColor;

  /// default: null
  /// maximum allowed character length that user can input from keyboard
  final int? maxLength;

  /// default: TextInputAction.next
  /// to display option on keyboard TextInputAction.next / TextInputAction.done
  final TextInputAction? textInputAction;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType ?? TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        prefixIcon: widget.prefix,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 45),
          borderSide: BorderSide(
            width: widget.borderWidth ?? 1,
          ),
        ),
        counterText: "",
        labelStyle: TextStyle(
          fontWeight: widget.labelWeight ?? FontWeight.w600,
        ),
        hintStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: widget.unfocusedColor ??
              Theme.of(context).colorScheme.background.withOpacity(0.25),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.unfocusedColor ??
                Theme.of(context).colorScheme.background.withOpacity(0.25),
            width: widget.borderWidth ?? 1,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 45),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusedColor ?? Theme.of(context).colorScheme.primary,
            width: widget.borderWidth ?? 1,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 45),
        ),
        hintText: widget.hintText,
        labelText: widget.labelText,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.r,
        ),
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.white,
      ),
    );
  }
}
