import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/logger.dart';
import '../widget/login_submit_state.dart';
import '../widget/password_field_state.dart';

part 'change_password_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class ChangePasswordPageState with _$ChangePasswordPageState {
  factory ChangePasswordPageState._({
    @Default("パスワード変更") String pageTitle,
    required GlobalKey<FormState> formKey,
    required PasswordFieldStateProvider passwordFieldStateProvider,
    required LoginSubmitStateProvider onSubmitStateProvider,
  }) = _ChangePasswordPageState;

  factory ChangePasswordPageState.create({
    required LoginSubmitStateProvider onSubmitStateProvider,
  }) {
    return ChangePasswordPageState._(
      formKey: GlobalKey<FormState>(),
      passwordFieldStateProvider: passwordFieldStateNotifierProviderCreator(),
      onSubmitStateProvider: onSubmitStateProvider,
    );
  }
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class ChangePasswordPageStateNotifier
    extends StateNotifier<ChangePasswordPageState> {
  ChangePasswordPageStateNotifier({
    required this.ref,
  }) : super(
          ChangePasswordPageState.create(
            onSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
              loginSubmitWidgetName: "",
              onSubmit: () {},
            ),
          ),
        ) {
    initial();
  }

  final Ref ref;

  void initial() {
    final onSubmitStateProvider = loginSubmitStateNotifierProviderCreator(
      loginSubmitWidgetName: state.pageTitle,
      onSubmit: () {
        logger.d(" change password ");
      },
    );

    ChangePasswordPageState.create(
      onSubmitStateProvider: onSubmitStateProvider,
    );
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final changePasswordPageStateProvider = StateNotifierProvider<
    ChangePasswordPageStateNotifier, ChangePasswordPageState>(
  (ref) {
    return ChangePasswordPageStateNotifier(ref: ref);
  },
);
