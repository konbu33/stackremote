import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'channel_name_field_state.dart';

class ChannelNameFieldWidget extends HookConsumerWidget {
  const ChannelNameFieldWidget({
    Key? key,
    required this.channelNameFieldStateProvider,
  }) : super(key: key);

  final ChannelNameFieldStateProvider channelNameFieldStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(channelNameFieldStateProvider);
    final notifier = ref.read(channelNameFieldStateProvider.notifier);

    return Column(
      children: [
        TextFormField(
          focusNode: state.focusNode,
          key: state.channelNameFieldKey,
          controller: state.channelNameFieldController,
          onChanged: (text) {
            state.channelNameFieldKey.currentState!.validate();
          },

          // 入力値の長さ制限
          maxLength: state.channelNameMaxLength,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(state.channelNameFieldName),

            // 入力フィールドの色・枠
            prefixIcon: state.channelNameIcon,

            // ヘルパー・エラーメッセージ表示
            counterText: "",
          ),

          // バリデーション
          validator: (value) {
            notifier.channelNameCustomValidator(value ?? "");
            return;
          },
        ),
        Text(
          state.channelNameIsValidate.message,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
