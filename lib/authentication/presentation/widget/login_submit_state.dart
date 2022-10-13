import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'login_submit_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class LoginSubmitState with _$LoginSubmitState {
  const factory LoginSubmitState._({
    required String loginSubmitWidgetName,
    required Function onSubmit,
  }) = _LoginSubmitState;

  factory LoginSubmitState.create({
    required String loginSubmitWidgetName,
    required Function onSubmit,
  }) =>
      LoginSubmitState._(
        loginSubmitWidgetName: loginSubmitWidgetName,
        onSubmit: onSubmit,
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class LoginSubmitStateNotifier extends StateNotifier<LoginSubmitState> {
  LoginSubmitStateNotifier({
    required String loginSubmitWidgetName,
    required Function onSubmit,
  }) : super(LoginSubmitState.create(
          loginSubmitWidgetName: loginSubmitWidgetName,
          onSubmit: onSubmit,
        ));
}

// --------------------------------------------------
//
// typedef Provider
//
// --------------------------------------------------
typedef LoginSubmitStateProvider
    = StateNotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>;

// --------------------------------------------------
//
// StateNotifierProviderCreator
//
// --------------------------------------------------
LoginSubmitStateProvider loginSubmitStateNotifierProviderCreator({
  required String loginSubmitWidgetName,
  required Function onSubmit,
}) {
  return StateNotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>(
    (ref) => LoginSubmitStateNotifier(
      loginSubmitWidgetName: loginSubmitWidgetName,
      onSubmit: onSubmit,
    ),
  );
}
