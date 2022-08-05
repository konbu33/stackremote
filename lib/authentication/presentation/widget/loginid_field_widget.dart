import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/state/loginid_field_state.dart';

class LoginIdFieldWidget extends HookConsumerWidget {
  const LoginIdFieldWidget(
      {Key? key, required this.state, required this.notifier})
      : super(key: key);

  final LoginIdFieldState state;
  final notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return
        // Material(
        //   color: Colors.transparent,
        //   // color: Colors.grey[100].withOpacity(0.5),
        //   // elevation: 2,
        //   // shadowColor: Colors.grey,
        //   shadowColor: Colors.grey,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(32),
        //   ),
        //   child:

        Column(
      children: [
        TextFormField(
          key: state.loginidKey.value,
          // key: GlobalKey<FormFieldState>(),
          controller: state.loginidController.value,
          onChanged: (t) {
            notifier.changeIsSubmitable();
          },

          // 入力値の長さ制限
          maxLength: state.maxLength,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(state.loginFieldName),

            // 入力フィールドの色・枠
            prefixIcon: state.loginIdIcon.value,
            // border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(30),
            //     borderSide: BorderSide.none),
            // fillColor: Colors.grey[200],
            // fillColor: Colors.grey.withOpacity(0.3),
            // filled: true,

            // ヘルパー・エラーメッセージ表示
            counterText: "",
            // helperText: state.validateSuccess ? "Check : OK" : "",
            // helperStyle: const TextStyle(color: Colors.blue),
          ),

          // バリデーション
          validator: (value) {
            // return notifier.customValidator(value);
            final message = notifier.customValidator(value);
            print("message : ${message}");
            if (message == null) {
              // notifier.changeValidatorMessage("Check : OK");
            } else {
              notifier.changeValidatorMessage(message);
            }
            return message;
          },
          // ),
        ),
        Text(state.validatorMessage, style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
