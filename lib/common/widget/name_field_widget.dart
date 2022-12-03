import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/common/validation.dart';

import 'name_field_state.dart';

class NameFieldWidget extends HookConsumerWidget {
  const NameFieldWidget({
    Key? key,
    required this.nameFieldStateNotifierProvider,
  }) : super(key: key);

  final NameFieldStateNotifierProvider nameFieldStateNotifierProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nameFieldStateNotifierProvider);
    final notifier = ref.watch(nameFieldStateNotifierProvider.notifier);

    return Column(
      children: [
        TextFormField(
          focusNode: state.focusNode,
          key: state.formFieldKey,
          controller: state.textEditingController,
          onChanged: (text) {
            state.formFieldKey.currentState!.validate();
          },

          // 入力値の長さ制限
          maxLength: state.maxLength,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(state.name),

            // 入力フィールドの色・枠
            prefixIcon: state.icon,

            // ヘルパー・エラーメッセージ表示
            counterText: "",
          ),

          // バリデーション
          validator: (value) {
            final validation = state.validator(value ?? "");
            notifier.updateIsValidate(validation);
            return;
          },
        ),
        Text(
          state.isValidate.message,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
