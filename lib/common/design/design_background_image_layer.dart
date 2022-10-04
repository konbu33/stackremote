import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import '../assets.gen.dart';

class DesignBackgroundImageLayer extends SingleChildStatelessWidget {
  const DesignBackgroundImageLayer({
    Key? key,
    Widget? child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    // return SafeArea(
    // child: Container(
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
