import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/pointer_state.dart';

// --------------------------------------------------
//
// PointerWidgetLocalState
//
// --------------------------------------------------
class PointerWidgetLocalState {
  final commentTextEidtingController = StateProvider.autoDispose((ref) {
    // stateの初期化時のみ、commentを引数に指定したいため、watch指定せずに、read指定している。
    final comment =
        ref.read(pointerStateNotifierProvider.select((value) => value.comment));

    return TextEditingController(text: comment);
  });

  final focusNode = FocusNode();

  // --------------------------------------------------
  //
  // onTapProvider
  //
  // --------------------------------------------------
  final onTapProvider = Provider((ref) {
    void Function() buildOnTap() {
      return () {
        final pointerStateNotifier =
            ref.read(pointerStateNotifierProvider.notifier);

        pointerStateNotifier.updateIsOnLongPressing(false);
        pointerStateNotifier.updatePointerPosition(const Offset(0, 0));
      };
    }

    return buildOnTap;
  });
}

// --------------------------------------------------
//
// PointerWidgetLocalStateProvider
//
// --------------------------------------------------
typedef PointerWidgetLocalStateProvider = Provider<PointerWidgetLocalState>;

// --------------------------------------------------
//
// pointerWidgetLocalStateProviderCreattor
//
// --------------------------------------------------

PointerWidgetLocalStateProvider pointerWidgetLocalStateProviderCreattor() {
  return Provider((ref) {
    return PointerWidgetLocalState();
  });
}
