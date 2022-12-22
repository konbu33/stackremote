import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../domain/pointer_state.dart';
import 'pointer_widget_local.dart';
import 'pointer_widget_remote.dart';

class PointerPositionedWidget extends HookConsumerWidget {
  const PointerPositionedWidget({
    Key? key,
    this.comment,
    this.email,
    this.dx,
    this.dy,
    this.nickName,
  }) : super(key: key);

  final String? comment;
  final String? email;
  final double? dx;
  final double? dy;
  final String? nickName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final top = dy ?? 0;
    final left = dx ?? 0;

    return Positioned(
      top: top,
      left: left,
      child: Builder(
        builder: (context) {
          final pointerState = ref.watch(pointerStateNotifierProvider);
          if (email == pointerState.email) {
            return PointerWidgetLocal(
              nickName: nickName,
            );
          }

          return PointerWidgetRemote(
            comment: comment,
            nickName: nickName,
          );
        },
      ),
    );
  }
}
