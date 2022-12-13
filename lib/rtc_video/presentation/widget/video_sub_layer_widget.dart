import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../user/user.dart';
import 'rtc_video_local_preview_widget.dart';
import 'rtc_video_remote_preview_widget.dart';
import 'video_main_widget.dart';
import 'video_sub_widget.dart';

final videoSubLayerAlignmentProvider =
    StateProvider((ref) => AlignmentDirectional.bottomEnd);

// final remotePreviewIsDragStartProvider =
//     StateProvider.autoDispose((ref) => false);

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

        final Widget widget = GestureDetector(
            onTap: () {
              ref
                  .read(currentUidOfVideoMainProvider.notifier)
                  .update((state) => user.rtcVideoUid);
            },
            child: Column(children: [
              Expanded(
                child: currentUid == localUid
                    ? RtcVideoRemotePreviewWidget(remoteUid: user.rtcVideoUid)
                    : user.rtcVideoUid == localUid
                        ? const RtcVideoLocalPreviewWidget()
                        : RtcVideoRemotePreviewWidget(
                            remoteUid: user.rtcVideoUid),
              ),
              Text("${user.rtcVideoUid}"),
            ]));

        return ClippedVideoWidget(child: widget);

        //
      }).toList();

      final videoSubWidgetList =
          videoSubWidgetListNullable.whereType<Widget>().toList();

      return videoSubWidgetList.isEmpty
          ? const SizedBox()
          : Stack(
              alignment: videoSubLayerAlignment,
              children: [
                const Expanded(child: DragTargetWidget()),
                DraggableWidget(child: Wrap(children: videoSubWidgetList)),
              ],
            );

      // return videoSubWidgetList.isEmpty
      //     ? const SizedBox()
      //     : Container(
      //         color: Colors.transparent,
      //         child: Wrap(children: videoSubWidgetList),
      //       );
    });

    return child;
  }
}
