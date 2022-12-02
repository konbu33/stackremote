import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'login_submit_state.freezed.dart';

// --------------------------------------------------
//
// LoginSubmitState
//
// --------------------------------------------------
@freezed
class LoginSubmitState with _$LoginSubmitState {
  const factory LoginSubmitState._({
    required String loginSubmitWidgetName,
    required Function? onSubmit,
  }) = _LoginSubmitState;

  factory LoginSubmitState.create({
    required String loginSubmitWidgetName,
    required Function? onSubmit,
  }) =>
      LoginSubmitState._(
        loginSubmitWidgetName: loginSubmitWidgetName,
        onSubmit: onSubmit,
      );
}

// --------------------------------------------------
//
// LoginSubmitStateNotifier
//
// --------------------------------------------------
class LoginSubmitStateNotifier extends Notifier<LoginSubmitState> {
  LoginSubmitStateNotifier({
    required this.loginSubmitWidgetName,
    required this.onSubmit,
  });

  final String loginSubmitWidgetName;
  final Function? onSubmit;

  @override
  LoginSubmitState build() {
    final loginSubmitState = LoginSubmitState.create(
      loginSubmitWidgetName: loginSubmitWidgetName,
      onSubmit: onSubmit,
    );
    return loginSubmitState;
  }
}

// --------------------------------------------------
//
// loginSubmitStateNotifierProviderCreator
//
// --------------------------------------------------
typedef LoginSubmitStateProvider
    = NotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>;

LoginSubmitStateProvider loginSubmitStateNotifierProviderCreator({
  required String loginSubmitWidgetName,
  required Function? onSubmit,
}) {
  return NotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>(
    () => LoginSubmitStateNotifier(
      loginSubmitWidgetName: loginSubmitWidgetName,
      onSubmit: onSubmit,
    ),
  );
}
