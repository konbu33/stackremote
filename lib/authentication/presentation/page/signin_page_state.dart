import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/common/logger.dart';
// import 'package:stackremote/authentication/usecase/verify_email.dart';
import '../../domain/firebase_auth_user.dart';
import '../../infrastructure/authentication_service_firebase.dart';
import '../../usecase/authentication_service_signin_usecase.dart';
import '../widget/appbar_action_icon_state.dart';
import '../widget/login_submit_state.dart';
import '../widget/loginid_field_state.dart';
import '../widget/password_field_state.dart';

part 'signin_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class SignInPageState with _$SignInPageState {
  const factory SignInPageState._({
    // GoTo SignUp Submit Widget
    // ignore: unused_element
    @Default("新規登録") String goToSignUpIconOnSubmitWidgetName,
    required AppbarActionIconStateProvider goToSignUpIconStateProvider,

    // Login Id Field Widget
    required LoginIdFieldStateProvider loginIdFieldStateProvider,

    // Password Field Widget
    required PasswordFieldStateProvider passwordFieldStateProvider,

    // Login Submit Widget
    // ignore: unused_element
    @Default("サインイン") String loginSubmitWidgetName,
    required AuthenticationServiceSignInUsecase
        authenticationServiceSignInUsecase,
    required LoginSubmitStateProvider loginSubmitStateProvider,
    @Default(false) bool isOnSubmitable,
  }) = _SignInPageState;

  factory SignInPageState.create() => SignInPageState._(
        // GoTo Submit Widget
        goToSignUpIconStateProvider: appbarActionIconStateProviderCreator(
          onSubmitWidgetName: "",
          icon: const Icon(null),
          onSubmit: null,
        ),

        // Login Id Field Widget
        loginIdFieldStateProvider: loginIdFieldStateNotifierProviderCreator(),

        // Password Field Widget
        passwordFieldStateProvider: passwordFieldStateNotifierProviderCreator(),

        // Login Submit
        authenticationServiceSignInUsecase: AuthenticationServiceSignInUsecase(
            authenticationService: AuthenticationServiceFirebase(
                instance: firebase_auth.FirebaseAuth.instance)),

        loginSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
          loginSubmitWidgetName: "",
          onSubmit: null,
        ),
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class SignInPageStateNotifier extends StateNotifier<SignInPageState> {
  SignInPageStateNotifier({
    required this.ref,
  }) : super(SignInPageState.create()) {
    initial();
  }

  // ref
  final Ref ref;

  // initial
  void initial() {
    state = SignInPageState.create();
    setSignInOnSubmit();
    setGoToSignUpIconOnSubmit();
  }

  void updateIsOnSubmitable(
    bool isOnSubmitable,
  ) {
    logger.d("updateIsOnSubmitable : ----------------- ${isOnSubmitable}");
    state = state.copyWith(isOnSubmitable: isOnSubmitable);
  }

  void setSignInOnSubmit() {
    Function? buildOnSubmit() {
      if (!state.isOnSubmitable) {
        return null;
      }

      return ({
        required BuildContext context,
      }) =>
          () async {
            final email = ref
                .read(state.loginIdFieldStateProvider)
                .loginIdFieldController
                .text;
            final password = ref
                .read(state.passwordFieldStateProvider)
                .passwordFieldController
                .text;

            try {
              final res = await state.authenticationServiceSignInUsecase
                  .execute(email, password);

              final firebase_auth.User? user = res.user;
              if (user != null) {
                if (user.emailVerified == false) {
                  // print("sendVeryfyEmail Start  ------------------- : ");

                  // メール送信頻度が多いと、下記のエラーが発生するため、サインインと同時にメール送信は行わない。
                  // E/flutter (24396): [ERROR:flutter/lib/ui/ui_dart_state.cc(198)] Unhandled Exception: [firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.

                  // final sendVerifyEmail = ref.read(sendVerifyEmailProvider);
                  // sendVerifyEmail(user: user);

                  // print("sendVeryfyEmail End    ------------------- : ");
                }

                final notifier =
                    ref.read(firebaseAuthUserStateNotifierProvider.notifier);
                notifier.updateEmailVerified(user.emailVerified);
              }
            } on firebase_auth.FirebaseAuthException catch (e) {
              // print(e);
              switch (e.code) {
                case "user-not-found":
                  const SnackBar snackBar = SnackBar(
                    content: Text("メールアドレス未登録です。"),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  break;

                case "too-many-requests":
                  // print("e ------------------------ : $e");
                  const SnackBar snackBar = SnackBar(
                    content: Text("認証回数が上限に達しました。"),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  break;

                default:
              }
            }

            initial();
            // print("initial End    ------------------- : ");
          };
    }

    state = state.copyWith(
        loginSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
            loginSubmitWidgetName: state.loginSubmitWidgetName,
            onSubmit: buildOnSubmit()));
  }

  void setGoToSignUpIconOnSubmit() {
    Function? buildOnSubmit() {
      return ({
        required BuildContext context,
      }) =>
          () {
            logger.d("go to signup.");
            context.push('/signup');
          };
    }

    state = state.copyWith(
      goToSignUpIconStateProvider: appbarActionIconStateProviderCreator(
        onSubmitWidgetName: state.goToSignUpIconOnSubmitWidgetName,
        icon: const Icon(Icons.person_add),
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
final signInPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<SignInPageStateNotifier, SignInPageState>(
  (ref) => SignInPageStateNotifier(ref: ref),
);
