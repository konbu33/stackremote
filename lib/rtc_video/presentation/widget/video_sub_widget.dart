import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../user/user.dart';

import 'clipped_video_widget.dart';
import 'drag_target_widget.dart';
import 'draggable_widget.dart';
import 'rtc_video_local_preview_widget.dart';
import 'rtc_video_remote_preview_widget.dart';
import 'video_sub_state.dart';

class VideoSubWidget extends StatelessWidget {
  const VideoSubWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final child = Consumer(builder: (context, ref, child) {
      final videoSubWidgetListCreator =
          ref.watch(VideoSubWidgetParts.videoSubWidgetListCreatorProvider);

      final videoSubWidgetList = videoSubWidgetListCreator();

      final videoSubLayerAlignment = ref.watch(videoSubStateNotifierProvider
          .select((value) => value.videoSubLayerAlignment));

      return videoSubWidgetList.isEmpty
          ? const SizedBox()
          : Stack(
              alignment: videoSubLayerAlignment,
              children: [
                VideoSubWidgetParts.dragTargetWidget(),
                VideoSubWidgetParts.draggableWidget(videoSubWidgetList),
              ],
            );
    });

    return child;
  }
}

class VideoSubWidgetParts {
  // dragTargetWidget
  static Widget dragTargetWidget() {
    final widget = Consumer(builder: (context, ref, child) {
      final updateVideoSubLayerAlignment = ref
          .watch(videoSubStateNotifierProvider.notifier)
          .updateVideoSubLayerAlignment;

      return DragTargetWidget(
        updateVideoSubLayerAlignment: updateVideoSubLayerAlignment,
      );
    });

    return widget;
  }

  // draggableWidget
  static Widget draggableWidget(List<Widget> videoSubWidgetList) {
    final widget = DraggableWidget(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          spacing: 10,
          children: videoSubWidgetList,
        ),
      ),
    );

    return widget;
  }

  // videoSubWidgetListCreatorProvider
  static final videoSubWidgetListCreatorProvider = Provider.autoDispose((ref) {
    //

    List<Widget> videoSubWidgetListCreator() {
      //
      final localUid = ref.watch(
          userStateNotifierProvider.select((value) => value.rtcVideoUid));

      final currentUidOfVideoMain = ref.watch(videoSubStateNotifierProvider
          .select((value) => value.currentUidOfVideoMain));

      final isOnTapIgnore = ref.watch(
          videoSubStateNotifierProvider.select((value) => value.isOnTapIgnore));

      final videoSubStateNotifier =
          ref.watch(videoSubStateNotifierProvider.notifier);

      final usersState = ref.watch(usersStateNotifierProvider);

      final videoSubWidgetListNullable = usersState.users.map((user) {
        logger.d(
            "currentUidOfVideoMain : $currentUidOfVideoMain, remoteUid : ${user.rtcVideoUid}, leaveAt : ${user.leavedAt}");

        // チャンネル離脱後のユーザは非表示
        if (user.leavedAt != null) return null;

        // メインVideoに表示中のcurrentユーザは非表示
        if (user.rtcVideoUid == currentUidOfVideoMain) return null;

        final child = AbsorbPointer(
          absorbing: isOnTapIgnore,
          child: GestureDetector(
            onTap: () {
              videoSubStateNotifier
                  .updateCurrentUidOfVideoMain(user.rtcVideoUid);

              videoSubStateNotifier.updateIsOnTapIgnore();
            },
            child: Column(
              children: [
                Expanded(
                  // --------------------------------------------------
                  // subのvideoViewを表示する際、
                  // local用のvideoPreviewで表示するか、あるいは，
                  // remote用のvideoPreviewで表示するか
                  // --------------------------------------------------

                  // --------------------------------------------------
                  // mainのvideoViewにlocalのvideoが表示されている場合、
                  // --------------------------------------------------
                  child: currentUidOfVideoMain == localUid

                      // subのvideoViewに表示するのは、remoteのvideoのみになるはずなので、
                      // すべてremote用videoPreviewで表示する。
                      ? RtcVideoRemotePreviewWidget(remoteUid: user.rtcVideoUid)

                      // --------------------------------------------------
                      // mainのvideoViewにlocalのvideoが表示されていない場合、
                      // --------------------------------------------------
                      : user.rtcVideoUid == localUid

                          // localのUidだったら、local用videoPreviewで表示する。
                          ? const RtcVideoLocalPreviewWidget()

                          // それ以外は、remote用videoPreviewで表示する。
                          : RtcVideoRemotePreviewWidget(
                              remoteUid: user.rtcVideoUid),

                  //
                ),
                // Text("${user.rtcVideoUid}"),
              ],
            ),
          ),
        );

        return ClippedVideoWidget(child: child);

        //
      }).toList();

      final videoSubWidgetList =
          videoSubWidgetListNullable.whereType<Widget>().toList();
      return videoSubWidgetList;
    }

    return videoSubWidgetListCreator;
  });
}
