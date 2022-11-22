import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/pointer_state.dart';

// --------------------------------------------------
//
// PointerWidgetLocalState
//
// --------------------------------------------------
class PointerWidgetLocalState {
  final commentTextEidtingController = Provider.autoDispose((ref) {
    return TextEditingController();
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
