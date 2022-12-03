import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'on_submit_button_state.freezed.dart';

// --------------------------------------------------
//
// OnSubmitButtonState
//
// --------------------------------------------------
@freezed
class OnSubmitButtonState with _$OnSubmitButtonState {
  const factory OnSubmitButtonState._({
    required String onSubmitButtonWidgetName,
    required Function? onSubmit,
  }) = _OnSubmitButtonState;

  factory OnSubmitButtonState.create({
    required String onSubmitButtonWidgetName,
    required Function? onSubmit,
  }) =>
      OnSubmitButtonState._(
        onSubmitButtonWidgetName: onSubmitButtonWidgetName,
        onSubmit: onSubmit,
      );
}

// --------------------------------------------------
//
// OnSubmitButtonStateNotifier
//
// --------------------------------------------------
class OnSubmitButtonStateNotifier extends Notifier<OnSubmitButtonState> {
  OnSubmitButtonStateNotifier({
    required this.onSubmitButtonWidgetName,
    required this.onSubmit,
  });

  final String onSubmitButtonWidgetName;
  final Function? onSubmit;

  @override
  OnSubmitButtonState build() {
    final onSubmitButtonState = OnSubmitButtonState.create(
      onSubmitButtonWidgetName: onSubmitButtonWidgetName,
      onSubmit: onSubmit,
    );
    return onSubmitButtonState;
  }
}

// --------------------------------------------------
//
// OnSubmitButtonStateNotifierProviderCreator
//
// --------------------------------------------------
typedef OnSubmitButtonStateNotifierProvider
    = NotifierProvider<OnSubmitButtonStateNotifier, OnSubmitButtonState>;

OnSubmitButtonStateNotifierProvider onSubmitButtonStateNotifierProviderCreator({
  required String onSubmitButtonWidgetName,
  required Function? onSubmit,
}) {
  return NotifierProvider<OnSubmitButtonStateNotifier, OnSubmitButtonState>(
    () => OnSubmitButtonStateNotifier(
      onSubmitButtonWidgetName: onSubmitButtonWidgetName,
      onSubmit: onSubmit,
    ),
  );
}
