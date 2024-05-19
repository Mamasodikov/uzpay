import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DottedBorderWidget extends StatelessWidget {
  final Widget child;

  const DottedBorderWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: DottedBorder(
        color: Colors.blue,
        strokeWidth: 1,
        dashPattern: [4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(18),
        child: child,
      ),
    );
  }
}
