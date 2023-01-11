import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../user/user.dart';
import 'pointer_overlay_state.dart';

class PointerWidgetRemote extends ConsumerWidget {
  const PointerWidgetRemote({
    super.key,
    this.comment,
    this.nickName,
    required this.userColor,
  });

  final String? comment;
  final String? nickName;
  final UserColor userColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointerTextFormFieldWidth =
        ref.watch(PointerOverlayState.pointerTextFormFieldWidthProvider);

    final textStyle = TextStyle(color: userColor.color);

    return GestureDetector(
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
                // color: Colors.black,
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
                controller: TextEditingController(text: comment),
                enabled: false,
                readOnly: true,

                // 複数行入力
                keyboardType: TextInputType.multiline,
                maxLines: null,

                decoration: InputDecoration(
                  // ユーザ名
                  labelText: nickName ?? "no name",
                ),

                style: textStyle,

                // 画面タップすることで、TextFormFieldからフォーカスを外せるようにする。
              ),
            ),
          ),
        ],
      ),
    );
  }
}
