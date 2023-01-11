import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../domain/pointer_state.dart';
import 'pointer_widget_local_state.dart';

class PointerOverlayState {
  // --------------------------------------------------
  //
  // pointerTextFormFieldWidthProvider
  // pointerWidgetLocalStateProvider
  //
  // --------------------------------------------------
  static final pointerTextFormFieldWidthProvider =
      StateProvider((ref) => MinMax<double>.create(min: 100, max: 150));

  static final pointerWidgetLocalStateProvider =
      pointerWidgetLocalStateProviderCreattor();

  // --------------------------------------------------
  //
  // onTapProvider
  //
  // --------------------------------------------------
  static final onTapProvider = Provider((ref) {
    void Function() buildOnTap() {
      return () {
        final pointerWidgetLocalState =
            ref.read(pointerWidgetLocalStateProvider);

        pointerWidgetLocalState.focusNode.unfocus();
      };
    }

    return buildOnTap;
  });

  // --------------------------------------------------
  //
  // onLongPressStartProvider
  //
  // --------------------------------------------------
  static final onLongPressStartProvider = Provider((ref) {
    void Function(LongPressStartDetails) buildOnLongPressStart() {
      return (
        LongPressStartDetails event,
      ) {
        final pointerStateNotifier =
            ref.read(pointerStateNotifierProvider.notifier);

        pointerStateNotifier.updateIsOnLongPressing(true);
        pointerStateNotifier.updatePointerPosition(event.localPosition);
      };
    }

    return buildOnLongPressStart;
  });

  // --------------------------------------------------
  //
  // onLongPressMoveUpdateProvider
  //
  // --------------------------------------------------
  static final onLongPressMoveUpdateProvider = Provider((ref) {
    void Function(LongPressMoveUpdateDetails) buildOnLongPressMoveUpdate() {
      return (
        LongPressMoveUpdateDetails event,
      ) {
        final pointerStateNotifier =
            ref.read(pointerStateNotifierProvider.notifier);

        pointerStateNotifier.updatePointerPosition(event.localPosition);
      };
    }

    return buildOnLongPressMoveUpdate;
  });
}
