import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/color_constants.dart';
import 'custom_text.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField.field({
    super.key,
    required this.controller,
    this.focusNode,
    this.text,
    this.textSize,
    this.textWeight,
    this.textColor,
    this.spacing,
    this.maxLines,
    this.minLines,
    this.onTap,
    this.onChanged,
    this.onTapOutSide,
    this.onSubmitted,
    this.autoValidateMode,
    this.validator,
    this.borderRadius,
    this.borderWidth,
    this.labelWeight = CustomFontWeight.semiBold,
    this.labelSize = CustomFontSize.small,
    this.labelText,
    this.labelTextColor,
    this.hintText,
    this.prefix,
    this.suffix,
    this.textInputType,
    this.unfocusedColor,
    this.focusedColor,
    this.maxLength,
    this.textInputAction,
  });

  const CustomTextField.text({
    super.key,
    required this.text,
    this.focusNode,
    this.textSize,
    this.textWeight,
    this.textColor,
    this.spacing,
    this.controller,
    this.maxLines,
    this.minLines,
    this.onTap,
    this.onChanged,
    this.onTapOutSide,
    this.onSubmitted,
    this.autoValidateMode,
    this.validator,
    this.borderRadius,
    this.borderWidth,
    this.labelWeight = CustomFontWeight.normal,
    this.labelSize = CustomFontSize.small,
    this.labelText,
    this.labelTextColor,
    this.hintText,
    this.prefix,
    this.suffix,
    this.textInputType,
    this.unfocusedColor,
    this.focusedColor,
    this.maxLength,
    this.textInputAction,
  });

  final TextEditingController? controller;

  final AutovalidateMode? autoValidateMode;

  final double? spacing;

  /// default: null
  final String? text;

  /// default: null
  /// to manage focus on field
  final FocusNode? focusNode;

  /// default: Theme.of(context).colorScheme.onBackground
  final Color? textColor;

  /// default: CustomFontSize.normal
  final CustomFontSize? textSize;

  /// default: CustomFontSize.normal
  final CustomFontWeight? textWeight;

  /// default: 1
  /// to restrict multiline on field
  final int? maxLines;

  /// default: null
  /// to restrict multiline on field
  final int? minLines;

  /// default: null
  /// to observe changes on field
  final Function(String)? onChanged;

  /// default: null
  /// to get click on field
  final Function()? onTap;

  /// default: null (automatically removes focus from the field)
  /// to get Done/Next click of keyboard
  final Function(String value)? onSubmitted;

  /// default: null
  /// to get click outside of field
  final Function(PointerDownEvent event)? onTapOutSide;

  /// default: null
  /// to validate the field
  final String? Function(String? value)? validator;

  /// default: 45
  final double? borderRadius;

  /// default: 1
  final double? borderWidth;

  /// default: CustomFontWeight.semiBold
  final CustomFontWeight? labelWeight;

  /// default: CustomFontSize.normal
  final CustomFontSize? labelSize;

  /// default: null
  final String? labelText;

  /// default: null
  final Color? labelTextColor;

  /// default: null
  final String? hintText;

  /// default: null
  /// to display widget at start of the input field
  final Widget? prefix;

  /// default: null
  /// to display widget at end of the input field
  final Widget? suffix;

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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    FontWeight textWeight;
    if (widget.textWeight == null) {
      textWeight = FontWeight.w500;
    } else {
      if (widget.textWeight == CustomFontWeight.light) {
        textWeight = FontWeight.w200;
      } else if (widget.textWeight == CustomFontWeight.semiBold) {
        textWeight = FontWeight.w700;
      } else if (widget.textWeight == CustomFontWeight.bold) {
        textWeight = FontWeight.w900;
      } else {
        textWeight = FontWeight.w500;
      }
    }

    double textSize;
    if (widget.textSize == null) {
      textSize = 16.sp;
    } else {
      if (widget.textSize == CustomFontSize.smallExtra) {
        textSize = 12.sp;
      } else if (widget.textSize == CustomFontSize.small) {
        textSize = 14.sp;
      } else if (widget.textSize == CustomFontSize.large) {
        textSize = 18.sp;
      } else if (widget.textSize == CustomFontSize.largeExtra) {
        textSize = 20.sp;
      } else {
        textSize = 16.sp;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          CustomText(
            text: widget.labelText!,
            customFontWeight: widget.labelWeight,
            customFontSize: widget.labelSize,
            textColor: widget.labelTextColor ??
                Theme.of(context).colorScheme.onBackground,
          ),
          SizedBox(
            height: widget.spacing ?? 0.01.sh,
          ),
        ],
        if (widget.controller != null)
          TextFormField(
            focusNode: widget.focusNode,
            controller: widget.controller,
            onTap: widget.onTap,
            onTapOutside: widget.onTapOutSide,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            keyboardType: widget.textInputType ?? TextInputType.text,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            maxLength: widget.maxLength,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            validator: widget.validator,
            autovalidateMode: widget.autoValidateMode,
            decoration: InputDecoration(
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix,
              fillColor: ColorConstants.whiteColor,
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 45),
                borderSide: BorderSide(
                  width: widget.borderWidth ?? 1,
                  color: widget.unfocusedColor ??
                      Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.25),
                ),
              ),
              counterText: "",
              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: widget.unfocusedColor ??
                    Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.25),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.unfocusedColor ??
                      Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.25),
                  width: widget.borderWidth ?? 1,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 45),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.focusedColor ??
                      Theme.of(context).colorScheme.primary,
                  width: widget.borderWidth ?? 1,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 45),
              ),
              hintText: widget.hintText,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
            ),
            style: TextStyle(
              fontSize: textSize,
              fontWeight: textWeight,
              color: widget.textColor ??
                  Theme.of(context).colorScheme.onBackground,
            ),
          ),
        if (widget.text != null)
          CustomText(
            text: widget.text!,
            customFontWeight: widget.textWeight,
            customFontSize: widget.textSize,
            textColor:
                widget.textColor ?? Theme.of(context).colorScheme.onBackground,
          ),
      ],
    );
  }
}
