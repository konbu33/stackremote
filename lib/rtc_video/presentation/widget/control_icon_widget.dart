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
        tooltip: controlIconWidgetState.tooltip,
        icon: Icon(
          controlIconWidgetState.isX
              ? controlIconWidgetState.disableIcon
              : controlIconWidgetState.enableIcon,
          color: controlIconWidgetState.isX
              ? controlIconWidgetState.disableColor
              : Theme.of(context).primaryColor,
        ),
      );
    });
  }
}
