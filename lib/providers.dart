import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/custom_mouse_cursor/custom_mouse_cursor_overlayer_state.dart';

import 'custom_mouse_cursor/custom_mouse_cursor_overlayer_state_notifier.dart';

class Providers {
  const Providers();

  static final helloWorldProvider =
      StateProvider<String>((ref) => "Hello World Riverpod.");

  static final testProvider = Provider((ref) => ref.read(helloWorldProvider));

  static final CustomMouseCursorOverlayerStateNotifierProvider =
      StateNotifierProvider<CustomMouseCursorOverlayerStateNotifier,
              CustomMouseCursorOerlayerState>(
          (ref) => CustomMouseCursorOverlayerStateNotifier());
}
