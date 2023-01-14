import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'control_icon_widget_state.dart';

class ControlIconWidget extends ConsumerWidget {
  const ControlIconWidget({
    super.key,
    required this.controlIconWidgetState,
  });

  final ControlIconWidgetState controlIconWidgetState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(builder: (context) {
      //
      return IconButton(
        onPressed: controlIconWidgetState.onPressed,
        icon: Icon(
          controlIconWidgetState.isMute
              ? controlIconWidgetState.disableIcon
              : controlIconWidgetState.enableIcon,
          color: controlIconWidgetState.isMute
              ? controlIconWidgetState.disableColor
              : Theme.of(context).primaryColor,
        ),
      );
    });
  }
}
