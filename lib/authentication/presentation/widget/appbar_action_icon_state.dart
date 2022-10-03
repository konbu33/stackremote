import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'appbar_action_icon_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class AppbarActionIconState with _$AppbarActionIconState {
  const factory AppbarActionIconState._({
    required String onSubmitWidgetName,
    required Icon icon,
    required Function onSubmit,
  }) = _AppbarActionIconState;

  factory AppbarActionIconState.create({
    required String onSubmitWidgetName,
    required Icon icon,
    required Function onSubmit,
  }) =>
      AppbarActionIconState._(
        onSubmitWidgetName: onSubmitWidgetName,
        icon: icon,
        onSubmit: onSubmit,
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class AppbarActionIconStateNotifier
    extends StateNotifier<AppbarActionIconState> {
  AppbarActionIconStateNotifier({
    required String onSubmitWidgetName,
    required Icon icon,
    required Function onSubmit,
  }) : super(AppbarActionIconState.create(
          onSubmitWidgetName: onSubmitWidgetName,
          icon: icon,
          onSubmit: onSubmit,
        ));
}

// --------------------------------------------------
//
//  typedef Provider
//
// --------------------------------------------------
typedef AppbarActionIconStateProvider = StateNotifierProvider<
    AppbarActionIconStateNotifier, AppbarActionIconState>;

// --------------------------------------------------
//
//  StateNotifierProviderCreator
//
// --------------------------------------------------
AppbarActionIconStateProvider appbarActionIconStateProviderCreator({
  required String onSubmitWidgetName,
  required Icon icon,
  required Function onSubmit,
}) {
  return StateNotifierProvider<AppbarActionIconStateNotifier,
      AppbarActionIconState>(
    (ref) {
      return AppbarActionIconStateNotifier(
        onSubmitWidgetName: onSubmitWidgetName,
        icon: icon,
        onSubmit: onSubmit,
      );
    },
  );
}
