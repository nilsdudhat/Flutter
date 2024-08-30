import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class CustomCircularImage extends StatefulWidget {
  const CustomCircularImage({
    super.key,
    required this.size,
    required this.photoURL,
    required this.file,
    this.onImageClicked,
    this.editWidget,
    this.placeHolder,
    this.backgroundColor,
  });

  final double size;
  final String? photoURL;
  final File? file;
  final Widget? placeHolder;
  final Function()? onImageClicked;
  final Widget? editWidget;
  final Color? backgroundColor;

  @override
  State<CustomCircularImage> createState() => _CustomCircularImageState();
}

class _CustomCircularImageState extends State<CustomCircularImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipOval(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: widget.onImageClicked,
          customBorder: const CircleBorder(),
          child: Stack(
            children: [
              ((widget.photoURL != null) && widget.photoURL!.isNotEmpty)
                  ? Image.network(
                      widget.photoURL!,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (frame == null) {
                          return Container(
                            color: widget.backgroundColor ??
                                Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.25),
                            width: double.infinity,
                            height: double.infinity,
                            child: (widget.placeHolder != null)
                                ? widget.placeHolder
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: ColorConstants.whiteColor,
                                    ),
                                  ),
                          );
                        }
                        return child;
                      },
                    )
                  : (widget.file != null)
                      ? Image.file(widget.file!)
                      : Container(
                          color: widget.backgroundColor ??
                              Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.25),
                          width: double.infinity,
                          height: double.infinity,
                          child: (widget.placeHolder != null)
                              ? widget.placeHolder
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstants.whiteColor,
                                  ),
                                ),
                        ),
              if (widget.editWidget != null) widget.editWidget!,
            ],
          ),
        ),
      ),
    );
  }
}
