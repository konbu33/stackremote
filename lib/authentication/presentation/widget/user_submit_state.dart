// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'user_submit_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class UserSubmitState with _$UserSubmitState {
  const factory UserSubmitState._({
    required Widget userSubmitWidget,
    required String userSubmitWidgetName,
    required Function onSubmit,
  }) = _UserSubmitState;

  factory UserSubmitState.create({
    required String userSubmitWidgetName,
    required Function onSubmit,
  }) =>
      UserSubmitState._(
        userSubmitWidgetName: userSubmitWidgetName,
        userSubmitWidget: const Placeholder(),
        onSubmit: onSubmit,
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UserSubmitStateNotifier extends StateNotifier<UserSubmitState> {
  UserSubmitStateNotifier({
    required String userSubmitWidgetName,
    Function? onSubmit,
  }) : super(UserSubmitState.create(
          userSubmitWidgetName: userSubmitWidgetName,
          onSubmit: onSubmit ?? () {},
        ));

  void setOnSubmit(Function onSubmit) {
    state = state.copyWith(onSubmit: onSubmit);
  }
}
