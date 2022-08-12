import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'password_field_state.dart';

class PasswordFieldWidget extends HookConsumerWidget {
  const PasswordFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passwordFieldStateNotifierProvider);
    final notifier = ref.watch(passwordFieldStateNotifierProvider.notifier);

    // Passwordテキストフィールド
    return Column(
      children: [
        TextFormField(
          key: state.passwordFieldKey,
          controller: state.passwordFieldController,
          onChanged: (text) {
            state.passwordFieldKey.currentState!.validate();
          },

          // 入力値の長さ制限
          maxLength: state.passwordMaxLength,

          // 入力値の表示・非表示
          obscureText: state.passwordIsObscure,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(state.passwordFieldName),

            // 入力フィールドの色・枠
            prefixIcon: state.passwordIcon,

            // passwordの表示・非表示切り替え
            suffixIcon: GestureDetector(
              onTap: () {
                notifier.passwordToggleObscureText();
              },
              child: state.passwordIsObscure
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
            ),

            // ヘルパー・エラーメッセージ表示
            counterText: "",
          ),

          // バリデーション
          validator: (value) {
            notifier.passwordCustomValidator(value ?? "");
          },
        ),
        Text(state.passwordIsValidate.message,
            style: const TextStyle(color: Colors.red)),
      ],
    );
  }
}
