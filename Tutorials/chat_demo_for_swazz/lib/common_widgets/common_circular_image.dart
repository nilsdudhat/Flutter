import 'dart:io';

import 'package:flutter/material.dart';

class CommonCircularImage extends StatefulWidget {
  const CommonCircularImage({
    super.key,
    required this.size,
    required this.photoURL,
    required this.file,
    this.iconData,
    this.onImageClicked,
    this.editWidget,
  });

  final double size;
  final String? photoURL;
  final File? file;
  final IconData? iconData;
  final Function()? onImageClicked;
  final Widget? editWidget;

  @override
  State<CommonCircularImage> createState() => _CommonCircularImageState();
}

class _CommonCircularImageState extends State<CommonCircularImage> {
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
                            color: Colors.white.withOpacity(0.25),
                            width: double.infinity,
                            height: double.infinity,
                            child: (widget.iconData != null)
                                ? Icon(
                                    widget.iconData,
                                    size: widget.size * 0.50,
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
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
                          color: Colors.white.withOpacity(0.25),
                          width: double.infinity,
                          height: double.infinity,
                          child: (widget.iconData != null)
                              ? Icon(
                                  widget.iconData,
                                  size: widget.size * 0.50,
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
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
