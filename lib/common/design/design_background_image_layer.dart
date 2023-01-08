import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import '../assets.gen.dart';

class DesignBackgroundImageLayer extends SingleChildStatelessWidget {
  const DesignBackgroundImageLayer({
    super.key,
    Widget? child,
  }) : super(
          child: child,
        );

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          repeat: ImageRepeat.repeat,
          image: AssetImage(Assets.images.backgroundImageFigma.path),
        ),
      ),
      child: child,
    );
  }
}
