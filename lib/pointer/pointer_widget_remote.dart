import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pointer_overlay_state.dart';

class PointerWidgetRemote extends HookConsumerWidget {
  const PointerWidgetRemote({
    Key? key,
    this.nickName,
    this.comment,
  }) : super(key: key);

  final String? nickName;
  final String? comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointerOverlayStateNotifierProvider);
    final notifier = ref.read(pointerOverlayStateNotifierProvider.notifier);

    return GestureDetector(
      onTap: () async {
        // // ポインタ押下して、ポインタ非表示し、位置もリセット。
        // notifier.changeOnLongPress(isOnLongPressing: false);
        // notifier.updatePosition(const Offset(0, 0));

        // // DBのポインタ情報を更新
        // final pointerOerlayerState =
        //     ref.watch(pointerOverlayStateNotifierProvider);

        // final firebaseAuthUser =
        //     ref.read(firebaseAuthUserStateNotifierProvider);

        // if (email == firebaseAuthUser.email) {
        //   final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);
        //   userUpdateUsecase(
        //     isOnLongPressing: false,
        //     pointerPosition: const Offset(0, 0),
        //   );
        // }

        // userUpdateUsecase(
        //   isOnLongPressing: pointerOerlayerState.isOnLongPressing,
        //   pointerPosition: pointerOerlayerState.pointerPosition,
        // );
      },
      child: Row(
        // Pointerを左上に固定
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.arrow_up_left),
          SizedBox(
            width: 100,
            child: TextFormField(
              // controller: state.commentController,
              controller: TextEditingController(text: comment),
              readOnly: true,

              // 複数行入力
              keyboardType: TextInputType.multiline,
              maxLines: null,

              decoration: InputDecoration(
                // ユーザ名
                // labelText: state.name,
                labelText: nickName ?? "no name",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
