import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../user/user.dart';

import 'rtc_video_local_preview_widget.dart';
import 'rtc_video_remote_preview_widget.dart';
import '../../domain/display_size_video_state.dart';
import 'video_sub_state.dart';

class VideoMainWidget extends StatelessWidget {
  const VideoMainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final currentUidOfVideoMain = ref.watch(videoSubStateNotifierProvider
          .select((value) => value.currentUidOfVideoMain));

      final localUid = ref.watch(
          userStateNotifierProvider.select((value) => value.rtcVideoUid));

      return LayoutBuilder(builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth.floorToDouble(),
          constraints.maxHeight.floorToDouble(),
        );

        void setDisplaySizeVideoMain(Size? size) {
          if (size == null) return;

          ref
              .read(DisplaySizeVideoState.displaySizeVideoMainProvider.notifier)
              .update((state) => size);
        }

        final buildedCallback = ref.watch(buildedCallbackProvider);

        buildedCallback<Size>(callback: setDisplaySizeVideoMain, data: size);

        final displaySizeVideoMainMin =
            ref.watch(DisplaySizeVideoState.displaySizeVideoMainMinProvider);

        return SizedBox(
          height: displaySizeVideoMainMin.height,
          width: displaySizeVideoMainMin.width,
          child: Column(
            children: [
              Expanded(
                child: currentUidOfVideoMain == localUid
                    ? const RtcVideoLocalPreviewWidget()
                    : RtcVideoRemotePreviewWidget(
                        remoteUid: currentUidOfVideoMain),
              ),
              SizedBox(
                height: 30,
                child: Text(
                    "displaySizeVideoMainMin: h: ${displaySizeVideoMainMin.height}, w: ${displaySizeVideoMainMin.width}"),
              ),
            ],
          ),
        );
      });
    });
  }
}
