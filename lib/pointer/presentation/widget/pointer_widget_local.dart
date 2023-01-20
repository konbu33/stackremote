import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../user/user.dart';
import '../../domain/pointer_state.dart';
import 'pointer_overlay_state.dart';

class PointerWidgetLocal extends ConsumerWidget {
  const PointerWidgetLocal({
    super.key,
    this.nickName,
    required this.userColor,
  });

  final String? nickName;
  final UserColor userColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointerWidgetLocalState =
        ref.watch(PointerOverlayState.pointerWidgetLocalStateProvider);

    final commentTextEidtingController =
        ref.watch(pointerWidgetLocalState.commentTextEidtingController);

    final onTap = ref.watch(pointerWidgetLocalState.onTapProvider);

    final pointerTextFormFieldWidth =
        ref.watch(PointerOverlayState.pointerTextFormFieldWidthProvider);

    final textStyle = TextStyle(color: userColor.color);

    return GestureDetector(
      // ポインタ非表示、ポインタ位置リセット
      onTap: onTap(),

      //
      child: Row(
        // Pointerを左上に固定
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(11, -8),
            child: Transform.rotate(
              angle: -0.9,
              child: Icon(
                Icons.navigation,
                // color: Theme.of(context).primaryColor,
                color: userColor.color,
              ),
            ),
          ),
          IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: pointerTextFormFieldWidth.min,
                maxWidth: pointerTextFormFieldWidth.max,
              ),
              child: TextFormField(
                controller: commentTextEidtingController,

                // 複数行入力
                keyboardType: TextInputType.multiline,
                maxLines: null,

                decoration: InputDecoration(
                  // ユーザ名
                  labelText: nickName ?? "no name",
                ),

                onChanged: (value) {
                  final pointerStateNotifier =
                      ref.read(pointerStateNotifierProvider.notifier);

                  pointerStateNotifier
                      .updateComment(commentTextEidtingController.text);
                },

                // 画面タップすることで、TextFormFieldからフォーカスを外せるようにする。
                focusNode: pointerWidgetLocalState.focusNode,

                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
