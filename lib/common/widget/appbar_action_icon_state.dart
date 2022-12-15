import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'appbar_action_icon_state.freezed.dart';

typedef AppbarActionIconOnSubmitFunction = void Function()? Function(
    {required BuildContext context});

// --------------------------------------------------
//
//   AppbarActionIconState
//
// --------------------------------------------------
@freezed
class AppbarActionIconState with _$AppbarActionIconState {
  const factory AppbarActionIconState._({
    required String onSubmitWidgetName,
    required Icon icon,
    required AppbarActionIconOnSubmitFunction onSubmit,
  }) = _AppbarActionIconState;

  factory AppbarActionIconState.create({
    required String onSubmitWidgetName,
    required Icon icon,
    required AppbarActionIconOnSubmitFunction onSubmit,
  }) =>
      AppbarActionIconState._(
        onSubmitWidgetName: onSubmitWidgetName,
        icon: icon,
        onSubmit: onSubmit,
      );
}

// --------------------------------------------------
//
// AppbarActionIconStateNotifier
//
// --------------------------------------------------
class AppbarActionIconStateNotifier extends Notifier<AppbarActionIconState> {
  AppbarActionIconStateNotifier({
    required this.appbarActionIconState,
  });

  final AppbarActionIconState appbarActionIconState;

  @override
  AppbarActionIconState build() {
    return AppbarActionIconState.create(
      onSubmitWidgetName: appbarActionIconState.onSubmitWidgetName,
      icon: appbarActionIconState.icon,
      onSubmit: appbarActionIconState.onSubmit,
    );
  }
}

// --------------------------------------------------
//
//  appbarActionIconStateNotifierProviderCreator
//
// --------------------------------------------------
typedef AppbarActionIconStateNotifierProvider
    = NotifierProvider<AppbarActionIconStateNotifier, AppbarActionIconState>;

AppbarActionIconStateNotifierProvider
    appbarActionIconStateNotifierProviderCreator({
  required AppbarActionIconState appbarActionIconState,
}) {
  return NotifierProvider<AppbarActionIconStateNotifier, AppbarActionIconState>(
      () => AppbarActionIconStateNotifier(
            appbarActionIconState: appbarActionIconState,
          ));
}
