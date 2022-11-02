import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'loginid_field_state.dart';

class LoginIdFieldWidget extends HookConsumerWidget {
  const LoginIdFieldWidget({
    Key? key,
    required this.loginIdFieldStateProvider,
  }) : super(key: key);

  final LoginIdFieldStateProvider loginIdFieldStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginIdFieldStateProvider);
    final notifier = ref.read(loginIdFieldStateProvider.notifier);

    return Column(
      children: [
        TextFormField(
          focusNode: state.focusNode,
          key: state.loginIdFieldKey,
          controller: state.loginIdFieldController,
          onChanged: (text) {
            state.loginIdFieldKey.currentState!.validate();
          },

          // 入力値の長さ制限
          maxLength: state.loginIdMaxLength,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(state.loginIdFieldName),

            // 入力フィールドの色・枠
            prefixIcon: state.loginIdIcon,

            // ヘルパー・エラーメッセージ表示
            counterText: "",
          ),

          // バリデーション
          validator: (value) {
            notifier.loginIdCustomValidator(value ?? "");
          },
        ),
        Text(
          state.loginIdIsValidate.message,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
