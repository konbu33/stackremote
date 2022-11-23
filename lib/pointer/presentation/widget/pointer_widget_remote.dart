import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PointerWidgetRemote extends HookConsumerWidget {
  const PointerWidgetRemote({
    Key? key,
    this.comment,
    this.nickName,
  }) : super(key: key);

  final String? comment;
  final String? nickName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Row(
        // Pointerを左上に固定
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.arrow_up_left),
          SizedBox(
            width: 100,
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

              // 画面タップすることで、TextFormFieldからフォーカスを外せるようにする。
            ),
          ),
        ],
      ),
    );
  }
}