import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import 'design_background_image_layer.dart';
import 'design_theme_layer.dart';

class DesignNestedLayer extends StatelessWidget {
  const DesignNestedLayer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Nested(
      children: const [
        DesignThemeLayer(),
        DesignBackgroundImageLayer(),
      ],
      child: child,
    );
  }
}
