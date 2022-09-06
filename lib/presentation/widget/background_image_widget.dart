import 'package:flutter/material.dart';

import '../../common/assets.gen.dart';

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(Assets.images.backgroundImageFigma.path),
          ),
        ),
        child: child,
      ),
    );
  }
}
