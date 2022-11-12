import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../user/user.dart';

import 'pointer_overlay_state.dart';
import 'pointer_widget_list.dart';

class PointerOverlayWidget extends HookConsumerWidget {
  const PointerOverlayWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointerOverlayStateNotifierProvider);

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        // 画面タップすることで、TextFormFieldからフォーカスを外せるようにする。
        onTap: () => state.focusNode.unfocus(),

        // ロングタップすることで、ポイン表示開始
        onLongPressStart: (event) async {
          // DBのポインタ情報を更新
          final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

          userUpdateUsecase(
            isOnLongPressing: true,
            pointerPosition: event.localPosition,
          );
        },

        // ロングタップ中は、ポインタ表示
        onLongPressMoveUpdate: (event) async {
          // DBのポインタ情報を更新
          final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

          userUpdateUsecase(
            pointerPosition: event.localPosition,
          );
        },

        child: Container(
          // Container内にポインタが表示される。
          // ContainerのサイズをScaffoldのサイズに合わせるためにcolorを指定。
          // この点はより最適な改善がありそう。
          color: Colors.transparent,
          child: Stack(
            children: [
              child,

              // childの上位レイヤーにポインタを表示
              const PointerWidgetList(),
            ],
          ),
        ),
      ),
    );
  }
}
