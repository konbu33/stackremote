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
    required String userSubmitWidgetName,
    required Function onSubmit,
  }) = _UserSubmitState;

  factory UserSubmitState.create({
    required String userSubmitWidgetName,
    required Function onSubmit,
  }) =>
      UserSubmitState._(
        userSubmitWidgetName: userSubmitWidgetName,
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
    required Function onSubmit,
  }) : super(UserSubmitState.create(
          userSubmitWidgetName: userSubmitWidgetName,
          onSubmit: onSubmit,
        ));
}

// --------------------------------------------------
//
// typedef Provider
//
// --------------------------------------------------
typedef UserSubmitStateProvider
    = StateNotifierProvider<UserSubmitStateNotifier, UserSubmitState>;

// --------------------------------------------------
//
// StateNotifierProviderCreator
//
// --------------------------------------------------
Function userSubmitStateNotifierProviderCreator = ({
  required String userSubmitWidgetName,
  required Function onSubmit,
}) {
  return StateNotifierProvider<UserSubmitStateNotifier, UserSubmitState>(
    (ref) => UserSubmitStateNotifier(
      userSubmitWidgetName: userSubmitWidgetName,
      onSubmit: onSubmit,
    ),
  );
};
