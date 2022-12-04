import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'name_field_state.dart';

class NameFieldWidget extends HookConsumerWidget {
  const NameFieldWidget({
    Key? key,
    required this.nameFieldStateNotifierProvider,
  }) : super(key: key);

  final NameFieldStateNotifierProvider nameFieldStateNotifierProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameFieldState = ref.watch(nameFieldStateNotifierProvider);

    final nameFieldStateNotifier =
        ref.watch(nameFieldStateNotifierProvider.notifier);

    return Column(
      children: [
        TextFormField(
          focusNode: nameFieldState.focusNode,
          key: nameFieldState.formFieldKey,
          controller: nameFieldState.textEditingController,
          onChanged: (text) {
            nameFieldState.formFieldKey.currentState!.validate();
          },

          // 入力値の長さ制限
          maxLength: nameFieldState.maxLength,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(nameFieldState.name),

            // 入力フィールドの色・枠
            prefixIcon: nameFieldState.icon,

            // ヘルパー・エラーメッセージ表示
            counterText: "",
          ),

          // バリデーション
          validator: (value) {
            nameFieldStateNotifier.checkIsValidate(value ?? "");
            return;
          },
        ),
        Text(
          nameFieldState.isValidate.message,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
