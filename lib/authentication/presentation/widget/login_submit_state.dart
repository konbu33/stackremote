// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    required Widget loginSubmitWidget,
    required String loginSubmitWidgetName,
    required Function onSubmit,
  }) = _LoginSubmitState;

  factory LoginSubmitState.create({
    required String loginSubmitWidgetName,
    required Function onSubmit,
  }) =>
      LoginSubmitState._(
        loginSubmitWidgetName: loginSubmitWidgetName,
        loginSubmitWidget: const Placeholder(),
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
