import 'package:flutter/material.dart';

import '../../../user/user.dart';

class PointerIconCircle extends StatelessWidget {
  const PointerIconCircle({
    super.key,
    required this.userColor,
  });

  final UserColor userColor;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(10, -20),
      child: Transform.rotate(
        angle: -0.9,
        child: Icon(
          Icons.circle_sharp,
          size: 40,
          color: userColor.color.withOpacity(0.4),
        ),
      ),
    );
  }
}

class PointerIconCircleOutLine extends StatelessWidget {
  const PointerIconCircleOutLine({
    super.key,
    required this.userColor,
  });

  final UserColor userColor;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(10, -20),
      child: Transform.rotate(
        angle: -0.9,
        child: Icon(
          Icons.circle_outlined,
          size: 40,
          color: userColor.color.withOpacity(0.4),
        ),
      ),
    );
  }
}

class PointerIconNavigation extends StatelessWidget {
  const PointerIconNavigation({
    super.key,
    required this.userColor,
  });

  final UserColor userColor;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(11, -12),
      child: Transform.rotate(
        angle: -0.9,
        child: Icon(
          Icons.navigation,
          size: 30,
          color: userColor.color.withOpacity(0.4),
        ),
      ),
    );
  }
}
