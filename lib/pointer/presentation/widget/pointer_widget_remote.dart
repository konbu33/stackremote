import 'package:flutter/material.dart';

import '../../../user/user.dart';

class PointerWidgetRemote extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
