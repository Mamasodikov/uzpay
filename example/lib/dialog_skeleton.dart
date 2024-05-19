import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DialogSkeleton extends StatefulWidget {
  final Widget child;
  final String title, icon;
  final Color? color;
  final double? radius;
  final Color? textColor;
  final Color? iconColor;
  final FontWeight? fontWeight;
  final bool? isCloseVisible;
  final bool? isNoShadow;

  const DialogSkeleton(
      {Key? key,
        required this.child,
        required this.title,
        required this.icon,
        this.color,
        this.radius,
        this.textColor,
        this.iconColor,
        this.fontWeight,
        this.isCloseVisible,
        this.isNoShadow})
      : super(key: key);

  @override
  State<DialogSkeleton> createState() => _DialogSkeletonState();
}

class _DialogSkeletonState extends State<DialogSkeleton> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Padding(
        // margin: EdgeInsets.only(
        //     bottom: MediaQuery.of(context).size.height / 5),
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Dialog(
          backgroundColor: widget.color,
          alignment: Alignment.center,
          shadowColor: widget.isNoShadow == true ? Colors.transparent : null,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius ?? 20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(widget.icon,
                        color: widget.iconColor ??
                            Theme.of(context).iconTheme.color,
                        height: 20,
                        width: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(widget.title,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: widget.fontWeight ?? FontWeight.w400,
                              fontFamily: 'Medium',
                              color: widget.textColor ??
                                  Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color)),
                    ),
                    Visibility(
                      visible: widget.isCloseVisible ?? true,
                      child: InkWell(
                        overlayColor:
                        MaterialStateProperty.all(Colors.transparent),
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset('assets/close.svg',
                            color: Theme.of(context).primaryColor,
                            width: 22,
                            height: 22),
                      ),
                    ),
                  ],
                ),
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}