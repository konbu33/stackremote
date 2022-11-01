import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication/authentication.dart';
import 'pointer_widget_local.dart';
import 'pointer_overlay_state.dart';
import 'pointer_widget_remote.dart';

class PointerPositionedWidget extends HookConsumerWidget {
  const PointerPositionedWidget({
    Key? key,
    this.dx,
    this.dy,
    this.nickName,
    this.email,
    this.comment,
  }) : super(key: key);

  final double? dx;
  final double? dy;
  final String? nickName;
  final String? email;
  final String? comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointerOverlayStateNotifierProvider);

    final top = dy ?? state.displayPointerPosition.dy;
    final left = dx ?? state.displayPointerPosition.dx;

    return Positioned(
      top: top,
      left: left,
      child: Builder(
        builder: (context) {
          final firebaseAuthUser =
              ref.read(firebaseAuthUserStateNotifierProvider);

          if (email == firebaseAuthUser.email) {
            return PointerWidgetLocal(
              nickName: nickName,
            );
          }

          return PointerWidgetRemote(
            nickName: nickName,
            comment: comment,
          );
        },
      ),
    );
  }
}
