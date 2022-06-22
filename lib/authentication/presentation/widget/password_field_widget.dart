import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/state/password_field_state.dart';

class PasswordFieldWidget extends HookConsumerWidget {
  const PasswordFieldWidget(
      {Key? key, required this.state, required this.notifier})
      : super(key: key);

  final PasswordFieldState state;
  final notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Passwordテキストフィールド
    return
        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(30),
        //     boxShadow: [
        //       BoxShadow(
        //           color: Colors.grey.withOpacity(0.5),
        //           blurRadius: 3,
        //           offset: Offset(2, 2)),
        //     ],
        //   ),
        //   child:

        Column(
      children: [
        TextFormField(
          key: state.passwordKey.value,
          // key: GlobalKey<FormFieldState>(),
          controller: state.passwordController.value,
          onChanged: (t) {
            notifier.changeIsSubmitable();
          },

          // 入力値の長さ制限
          maxLength: state.maxLength,

          // 入力値の表示・非表示
          obscureText: state.isObscure,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(state.passwordFieldName),

            // 入力フィールドの色・枠
            prefixIcon: state.passwordIcon.value,
            // border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(30),
            //     borderSide: BorderSide.none),
            // fillColor: Colors.grey[200],
            // filled: true,
            // isDense: true,

            // passwordの表示・非表示切り替え
            suffixIcon: GestureDetector(
              onTap: () => notifier.toggleObscureText(),
              child: state.isObscure
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
            ),

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
