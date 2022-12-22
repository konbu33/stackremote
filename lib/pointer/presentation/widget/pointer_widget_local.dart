import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/pointer_state.dart';
import 'pointer_overlay_state.dart';

class PointerWidgetLocal extends HookConsumerWidget {
  const PointerWidgetLocal({
    Key? key,
    this.nickName,
  }) : super(key: key);

  final String? nickName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointerWidgetLocalState =
        ref.watch(PointerOverlayState.pointerWidgetLocalStateProvider);

    final commentTextEidtingController =
        ref.watch(pointerWidgetLocalState.commentTextEidtingController);

    final onTap = ref.watch(pointerWidgetLocalState.onTapProvider);

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
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          // const Icon(CupertinoIcons.arrow_up_left),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: commentTextEidtingController,

              // 複数行入力
              keyboardType: TextInputType.multiline,
              maxLines: null,

              decoration: InputDecoration(
                // ユーザ名
                // labelText: state.name,
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
            ),
          ),
        ],
      ),
    );
  }
}
