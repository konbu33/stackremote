import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart';

class RtcVideoLocalPreviewWidget extends StatelessWidget {
  const RtcVideoLocalPreviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const SurfaceView();

      case TargetPlatform.iOS:
        return const SurfaceView();

      case TargetPlatform.windows:
        return const TextureView();

      case TargetPlatform.macOS:
        return const TextureView();

      default:
        return const Text(
          'Please join channel first',
          textAlign: TextAlign.center,
        );
    }
  }
}
