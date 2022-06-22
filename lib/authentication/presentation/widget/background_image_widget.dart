import 'package:flutter/material.dart';

import '../../common/gen/assets.gen.dart';

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({Key? key, required this.child})
      : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return
        // Theme(
        //   data: ThemeData(
        //     scaffoldBackgroundColor: Colors.white.withOpacity(0.8),
        //     appBarTheme: AppBarTheme(
        //         elevation: 0,
        //         backgroundColor: Colors.transparent,
        //         titleTextStyle: TextStyle(
        //           color: Colors.black87,
        //         )),
        //   ),
        //   child:
        Container(
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.red, width: 0),
        // Border.symmetric(
        //   horizontal:
        //       BorderSide(color: Colors.grey.withOpacity(0.5), width: 15),
        //   vertical: BorderSide(color: Colors.grey.withOpacity(0.5), width: 15),
        // ),
        // borderRadius: BorderRadius.circular(32),
        image: DecorationImage(
          repeat: ImageRepeat.repeat,
          // image: AssetImage(Assets.images.backgroundImage.path),
          image: AssetImage(Assets.images.backgroundImageFigma.path),
          // image: AssetImage(Assets.images.backgroundImageCloudPink.path),
          // image: AssetImage(Assets.images.backgroundImageCloudWhite.path),
          // image: AssetImage(Assets.images.imageFigma.path),
        ),
      ),
      child: child,
      // ),
    );
  }
}
