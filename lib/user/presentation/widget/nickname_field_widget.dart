import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'nickname_field_state.dart';

class NickNameFieldWidget extends HookConsumerWidget {
  const NickNameFieldWidget({
    Key? key,
    required this.nickNameFieldStateNotifierProvider,
  }) : super(key: key);

  final NickNameFieldStateNotifierProvider nickNameFieldStateNotifierProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nickNameFieldStateNotifierProvider);
    final notifier = ref.read(nickNameFieldStateNotifierProvider.notifier);

    return Column(
      children: [
        TextFormField(
          focusNode: state.focusNode,
          key: state.nickNameFieldKey,
          controller: state.nickNameFieldController,
          onChanged: (text) {
            state.nickNameFieldKey.currentState!.validate();
          },

          // 入力値の長さ制限
          maxLength: state.nickNameMaxLength,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(state.nickNameFieldName),

            // 入力フィールドの色・枠
            prefixIcon: state.nickNameIcon,

            // ヘルパー・エラーメッセージ表示
            counterText: "",
          ),

          // バリデーション
          validator: (value) {
            notifier.nickNameCustomValidator(value ?? "");
          },
        ),
        Text(
          state.nickNameIsValidate.message,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
