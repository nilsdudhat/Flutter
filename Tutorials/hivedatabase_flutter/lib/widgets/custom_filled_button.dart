import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomFilledButton extends StatefulWidget {
  const CustomFilledButton({
    super.key,
    required this.isFullWidth,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.splashColor,
    this.textColor,
    this.radius,
  });

  final Function() onPressed;
  final String text;

  /// to display full width button or not
  final bool isFullWidth;

  /// default: Theme.of(context).colorScheme.primary
  final Color? backgroundColor;

  /// default: Theme.of(context).colorScheme.inversePrimary
  final Color? splashColor;

  /// default: Theme.of(context).colorScheme.onPrimary
  final Color? textColor;

  /// default: 45
  final double? radius;

  @override
  State<CustomFilledButton> createState() => _CustomFilledButtonState();
}

class _CustomFilledButtonState extends State<CustomFilledButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
              widget.backgroundColor ?? Theme.of(context).colorScheme.primary),
          overlayColor: WidgetStateProperty.all(widget.splashColor ??
              Theme.of(context).colorScheme.inversePrimary),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 45))),
        ),
        child: CustomText(
          text: widget.text,
          textColor:
              widget.textColor ?? Theme.of(context).colorScheme.onPrimary,
          customFontWeight: CustomFontWeight.semiBold,
        ),
      ),
    );
  }
}
