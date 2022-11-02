import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

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
    // ignore: unused_element
    @Default("パスワード変更") String pageTitle,
    required GlobalKey<FormState> formKey,
    required PasswordFieldStateProvider passwordFieldStateProvider,
    required LoginSubmitStateProvider onSubmitStateProvider,
    // ignore: unused_element
    @Default("") String message,

    // ignore: unused_element
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

  void setMessage(String message) {
    state = state.copyWith(message: message);
  }

  void setChangePasswordOnSubmit() {
    Function? buildOnSubmit() {
      if (!state.isOnSubmitable) {
        return null;
      }

      return ({
        required BuildContext context,
      }) =>
          () async {
            // メールアドレスにURLを送信し、そのURLを押下してもらい、Firebase側のUIからパスワード変更する。
            // imporve: この方法の方が良い可能性あるため検討の余地あり。
            // final email = ref.read(firebaseAuthUserStateNotifierProvider).email;
            // FirebaseAuth.instance.sendPasswordResetEmail(email: email);

            // アプリ内のUIからパスワード変更する。
            final newPassword = ref
                .watch(state.passwordFieldStateProvider)
                .passwordFieldController
                .text;

            // improve: FirebaseAuthへの依存を無くしたい。
            final user = FirebaseAuth.instance.currentUser;

            final notifier = ref.read(changePasswordPageStateProvider.notifier);

            if (user != null) {
              try {
                await user.updatePassword(newPassword);

                const String message = "パスワード変更しました。";
                notifier.setMessage(message);
                //

              } on FirebaseException catch (e) {
                logger.d("$e");

                // improve: この関数は共通化した方が良さそう。
                String createErrorMessage(FirebaseException e) {
                  switch (e.code) {
                    case "requires-recent-login":
                      // imporve: 下記のエラーが発生する懸念がある。深堀り必要そう。
                      // Unhandled Exception: [firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.

                      const String message =
                          "前回のログインから一定時間が経過しているため、再ログインした後、改めて操作を行って下さい。";
                      return message;
                    default:
                      return "想定外のエラーが発生しました。再ログインし直して下さい。";
                  }
                }

                final String message = createErrorMessage(e);
                notifier.setMessage(message);
              }
            }
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
