import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'on_submit_button_state.dart';

class OnSubmitButtonWidget extends HookConsumerWidget {
  const OnSubmitButtonWidget({
    Key? key,
    required this.onSubmitButtonStateProvider,
  }) : super(key: key);

  final OnSubmitButtonStateProvider onSubmitButtonStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onSubmitButtonState = ref.watch(onSubmitButtonStateProvider);

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
            onPressed: onSubmitButtonState.onSubmit == null
                ? null
                : onSubmitButtonState.onSubmit!(context: context),
            child: Text(onSubmitButtonState.onSubmitButtonWidgetName),
          ),
        ),
      ],
    );
  }
}
