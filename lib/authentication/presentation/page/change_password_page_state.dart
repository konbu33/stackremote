import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/authentication.dart';

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
    @Default(false) bool isOnSubmitable,
  }) = _ChangePasswordPageState;

  factory ChangePasswordPageState.create() {
    return ChangePasswordPageState._(
      formKey: GlobalKey<FormState>(),
      passwordFieldStateProvider: passwordFieldStateNotifierProviderCreator(),
      onSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
        loginSubmitWidgetName: "",
        onSubmit: null,
      ),
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
          ChangePasswordPageState.create(),
        ) {
    initial();
  }

  final Ref ref;

  void initial() {
    setChangePasswordOnSubmit();
  }

  void updateIsOnSubmitable(bool isOnSubmitable) {
    state = state.copyWith(isOnSubmitable: isOnSubmitable);
  }

  void setChangePasswordOnSubmit() {
    Function? buildOnSubmit() {
      if (!state.isOnSubmitable) {
        return null;
      }

      return ({
        required BuildContext context,
      }) =>
          () {
            // メールアドレスにURLを送信し、そのURLを押下してもらい、Firebase側のUIからパスワード変更する。
            // final email = ref.read(firebaseAuthUserStateNotifierProvider).email;
            // FirebaseAuth.instance.sendPasswordResetEmail(email: email);

            // アプリ内のUIからパスワード変更する。
            final newPassword = ref
                .watch(state.passwordFieldStateProvider)
                .passwordFieldController
                .text;

            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              user.updatePassword(newPassword);
              // Unhandled Exception: [firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.
            }

            logger.d(" change password ");
          };
    }

    state = state.copyWith(
      onSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
        loginSubmitWidgetName: state.pageTitle,
        onSubmit: buildOnSubmit(),
      ),
    );
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final changePasswordPageStateProvider = StateNotifierProvider.autoDispose<
    ChangePasswordPageStateNotifier, ChangePasswordPageState>(
  (ref) {
    return ChangePasswordPageStateNotifier(ref: ref);
  },
);
