import 'package:agora_rtc_engine/rtc_local_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../user/user.dart';
import 'rtc_video_local_preview_widget.dart';
import 'rtc_video_remote_preview_widget.dart';
import 'video_main_widget.dart';
import 'video_sub_widget.dart';

class SubVideoLayerWidget extends HookConsumerWidget {
  const SubVideoLayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = Consumer(builder: (context, ref, child) {
      //
      final localUid = ref.watch(
          userStateNotifierProvider.select((value) => value.rtcVideoUid));

      final currentUid = ref.watch(currentUidOfVideoMainProvider);

      final usersState = ref.watch(usersStateNotifierProvider);
      final videoSubLayerAlignment = ref.watch(videoSubLayerAlignmentProvider);

      final videoSubWidgetListNullable = usersState.users.map((user) {
        logger.d(
            "currentUid : $currentUid, remoteUid : ${user.rtcVideoUid}, leaveAt : ${user.leavedAt}");

        // チャンネル離脱後のユーザは非表示
        if (user.leavedAt != null) return null;

        // メインVideoに表示中のcurrentユーザは非表示
        if (user.rtcVideoUid == currentUid) return null;

        Widget widget = Container(
            height: 150,
            width: 150,
            child: Column(
              children: [
                DraggableWidget(
                  rtcVideoUid: user.rtcVideoUid,
                  child: Container(
                      height: 30,
                      width: 30,
                      color: Colors.transparent,
                      child: Text("drag")),
                ),
                DraggableWidget(
                  rtcVideoUid: user.rtcVideoUid,
                  child: Container(
                      height: 90,
                      width: 90,
                      child: Stack(
                        children: [
                          ref.watch(remotePreviewIsDragStartProvider)
                              ? const SizedBox()
                              : const SurfaceView(),
                          Container(
                              height: 30,
                              width: 30,
                              color: Colors.orange,
                              child: Text("drag")),
                        ],
                      )),
                ),
                DraggableWidget(
                  rtcVideoUid: user.rtcVideoUid,
                  child: Container(
                      height: 30,
                      width: 30,
                      color: Colors.transparent,
                      child: Text("drag")),
                ),
              ],
            ));

        // widget = Container(
        //   color: Colors.blue,
        //   height: 100,
        //   width: 200,
        //   child: Column(children: [
        //     Text("${ref.watch(remotePreviewIsDragStartProvider)}",
        //         style: const TextStyle(fontSize: 10)),
        //     Text("${ref.watch(videoSubLayerAlignmentProvider)}",
        //         style: const TextStyle(fontSize: 10)),
        //   ]),
        // );

        // return VideoSubWidget(child: widget);
        // return ClippedVideoWidget(child: widget);
        return widget;
      }).toList();

      final videoSubWidgetList =
          videoSubWidgetListNullable.whereType<Widget>().toList();

      return videoSubWidgetList.isEmpty
          ? const SizedBox()
          : Stack(
              // alignment: videoSubLayerAlignment,
              children: [
                // const Expanded(child: DragTargetWidget()),
                // DraggableWidget(
                // child:
                Wrap(children: videoSubWidgetList),
                // ),
              ],
            );
    });

    return child;
  }
}
