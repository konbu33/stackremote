import 'package:flutter/material.dart';

class ClippedVideo extends StatelessWidget {
  const ClippedVideo({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: child,
      ),
    );
  }
}
