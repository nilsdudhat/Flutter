import 'package:flutter/material.dart';

class CommonOutlinedButton extends StatefulWidget {
  const CommonOutlinedButton.child({
    super.key,
    required this.isFullWidth,
    required this.onPressed,
    required this.child,
    this.borderColor,
    this.borderWidth,
    this.splashColor,
    this.textColor,
    this.radius,
    this.text,
  });

  const CommonOutlinedButton.text({
    super.key,
    required this.isFullWidth,
    required this.onPressed,
    required this.text,
    this.borderColor,
    this.borderWidth,
    this.splashColor,
    this.textColor,
    this.radius,
    this.child,
  });

  final Function() onPressed;

  /// default: null, if null then child variable will be required
  /// direct display of text
  final String? text;

  /// default: null, if null then text variable will be required
  /// direct display of child
  final Widget? child;

  /// to display full width button or not
  final bool isFullWidth;

  /// default: 1
  final double? borderWidth;

  /// default: Theme.of(context).colorScheme.primary
  final Color? borderColor;

  /// default: Theme.of(context).colorScheme.onPrimaryContainer
  final Color? splashColor;

  /// default: Theme.of(context).colorScheme.primary
  final Color? textColor;

  /// default: 45
  final double? radius;

  @override
  State<CommonOutlinedButton> createState() => _CommonOutlinedButtonState();
}

class _CommonOutlinedButtonState extends State<CommonOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(
              color:
                  widget.borderColor ?? Theme.of(context).colorScheme.primary,
              width: widget.borderWidth ?? 1)),
          foregroundColor: MaterialStateProperty.all(null),
          overlayColor: MaterialStateProperty.all(widget.splashColor ??
              Theme.of(context).colorScheme.onPrimaryContainer),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 45))),
        ),
        child: (widget.text != null)
            ? Text(
                widget.text!,
                style: TextStyle(
                    color: widget.textColor ??
                        Theme.of(context).colorScheme.primary),
              )
            : widget.child,
      ),
    );
  }
}
