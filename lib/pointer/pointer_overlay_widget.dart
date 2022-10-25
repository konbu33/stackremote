import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication/authentication.dart';
import '../rtc_video/rtc_video.dart';
import 'pointer_overlay_state.dart';
import 'pointer_positioned_widget.dart';

class PointerOverlayWidget extends HookConsumerWidget {
  const PointerOverlayWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointerOverlayStateNotifierProvider);

    final notifier = ref.read(pointerOverlayStateNotifierProvider.notifier);

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        // ロングタップすることで、ポイン表示開始
        onLongPressStart: (event) async {
          notifier.changeOnLongPress(isOnLongPressing: true);
          notifier.updatePosition(event.localPosition);

          final rtcChannelState = ref.watch(RtcChannelStateNotifierProviderList
              .rtcChannelStateNotifierProvider);

          final firebaseAuthUser =
              ref.watch(firebaseAuthUserStateNotifierProvider);

          final pointerOerlayerState =
              ref.watch(pointerOverlayStateNotifierProvider);

          final data = {
            "isOnLongPressing": pointerOerlayerState.isOnLongPressing,
            // "pointerPosition": event.localPosition.toString(),
            // "pointerPosition": pointerOerlayerState.pointerPosition.toString(),
            "pointerPosition": {
              "dx": pointerOerlayerState.pointerPosition.dx,
              "dy": pointerOerlayerState.pointerPosition.dy
            },
          };

          await FirebaseFirestore.instance
              .collection('channels')
              .doc(rtcChannelState.channelName)
              .collection('users')
              .doc(firebaseAuthUser.email)
              .update(data);
        },

        // ロングタップ中は、ポインタ表示
        onLongPressMoveUpdate: (event) async {
          notifier.updatePosition(event.localPosition);

          final rtcChannelState = ref.watch(RtcChannelStateNotifierProviderList
              .rtcChannelStateNotifierProvider);

          final firebaseAuthUser =
              ref.watch(firebaseAuthUserStateNotifierProvider);

          final pointerOerlayerState =
              ref.watch(pointerOverlayStateNotifierProvider);

          final data = {
            // "pointerPosition": event.localPosition.toString(),
            // "pointerPosition": pointerOerlayerState.pointerPosition.toString(),
            "pointerPosition": {
              "dx": pointerOerlayerState.pointerPosition.dx,
              "dy": pointerOerlayerState.pointerPosition.dy
            },
          };

          await FirebaseFirestore.instance
              .collection('channels')
              .doc(rtcChannelState.channelName)
              .collection('users')
              .doc(firebaseAuthUser.email)
              .update(data);
        },

        child: Container(
          // Container内にポインタが表示される。
          // ContainerのサイズをScaffoldの範囲に合わせるためにcolor指指。
          // この点は改善できそう。
          color: Colors.transparent,
          child: Stack(
            children: [
              child,
              // childの上位レイヤーにポインを表示
              if (state.isOnLongPressing) const PointerPositionedWidget(),

              // debug: ポインタの位置を表示
              Text(
                  "x:${(state.pointerPosition.dx.round())}, y:${state.pointerPosition.dy.round()}"),
            ],
          ),
        ),
      ),
    );
  }
}
