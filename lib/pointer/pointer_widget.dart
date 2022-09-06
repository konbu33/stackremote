import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pointer_overlay_state.dart';

class PointerWidget extends HookConsumerWidget {
  const PointerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointerOverlayStateNotifierProvider);
    final notifier = ref.read(pointerOverlayStateNotifierProvider.notifier);

    return GestureDetector(
      onTap: () {
        // ポインタ押下して、ポインタ非表示し、位置もリセット。
        notifier.changeOnLongPress(isOnLongPressing: false);
        notifier.updatePosition(const Offset(0, 0));
      },
      child: Row(
        // Pointerを左上に固定
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.arrow_up_left),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: state.commentController,

              // 複数行入力
              keyboardType: TextInputType.multiline,
              maxLines: null,

              decoration: InputDecoration(
                // ユーザ名
                labelText: state.name,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
