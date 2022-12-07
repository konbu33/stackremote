import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'on_submit_button_state.dart';

class OnSubmitButtonWidget extends HookConsumerWidget {
  const OnSubmitButtonWidget({
    Key? key,
    required this.onSubmitButtonStateNotifierProvider,
  }) : super(key: key);

  final OnSubmitButtonStateNotifierProvider onSubmitButtonStateNotifierProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onSubmitButtonState = ref.watch(onSubmitButtonStateNotifierProvider);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            )),
            onPressed: onSubmitButtonState.onSubmit(),
            child: Text(onSubmitButtonState.onSubmitButtonWidgetName),
          ),
        ),
      ],
    );
  }
}
