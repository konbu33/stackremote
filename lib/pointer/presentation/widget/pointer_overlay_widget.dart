import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/pointer_state.dart';
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
    // localのpointerState更新時に、リモートDB上へも反映するhooks
    ref.watch(updateUserIsOnLongPressingProvider);
    ref.watch(updateUserPointerPositionProvider);

    // onXXX の読み込み
    final onTap = ref.watch(PointerOverlayState.onTapProvider);

    final onLongPressStart =
        ref.watch(PointerOverlayState.onLongPressStartProvider);

    final onLongPressMoveUpdate =
        ref.watch(PointerOverlayState.onLongPressMoveUpdateProvider);

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        // 画面タップすることで、TextFormFieldからフォーカスを外せるようにする。
        onTap: onTap(),

        // ロングタップすることで、ポイン表示開始
        onLongPressStart: onLongPressStart(),

        // ロングタップ中は、ポインタ表示
        onLongPressMoveUpdate: onLongPressMoveUpdate(),

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
