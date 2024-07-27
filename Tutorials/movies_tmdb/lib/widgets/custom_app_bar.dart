import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      width: double.infinity,
      child: SafeArea(
        top: true,
        bottom: false,
        right: false,
        left: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SizedBox.expand(
                  child: leading,
                ),
              ),
              Expanded(
                child: Center(
                  child: CustomText(
                    text: title,
                    customFontWeight: CustomFontWeight.semiBold,
                    customFontSize: CustomFontSize.large,
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: SizedBox.expand(
                  child: trailing,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
