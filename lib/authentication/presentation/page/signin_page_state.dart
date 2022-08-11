import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common/validation.dart';
import '../authentication_service_firebase.dart';
import '../../usecase/authentication_service_signin_usecase.dart';

part 'signin_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class SignInPageState with _$SignInPageState {
  const factory SignInPageState._({
    // SignUp Field
    required Widget singUpWidget,

    // Login Id Field
    @Default("メールアドレス") String loginIdFieldName,
    required Widget loginIdField,
    required GlobalKey<FormFieldState> loginIdFieldKey,
    required TextEditingController loginIdFieldController,
    required Icon loginIdIcon,
    required Validation loginIdIsValidate,
    @Default(8) int loginIdMinLength,
    @Default(20) int loginIdMaxLength,

    // Password Field
    @Default("パスワード") String passwordFieldName,
    required Widget passwordField,
    required GlobalKey<FormFieldState> passwordFieldKey,
    required TextEditingController passwordFieldController,
    required Icon passwordIcon,
    required Validation passwordIsValidate,
    @Default(8) int passwordMinLength,
    @Default(20) int passwordMaxLength,
    @Default(true) bool passwordIsObscure,

    // Login Submit Widget
    @Default("サインイン") String loginSubmitWidgetName,
    required Widget loginSubmitWidget,
    required Function signIn,
  }) = _SignInPageState;

  factory SignInPageState.create() => SignInPageState._(
        // SignUp Field
        singUpWidget: const Placeholder(),

        // Login Id Field
        loginIdField: const Placeholder(),
        loginIdFieldKey: GlobalKey<FormFieldState>(),
        loginIdFieldController: TextEditingController(),
        loginIdIcon: const Icon(Icons.mail),
        loginIdIsValidate: Validation.create(),

        // Password Field
        passwordField: const Placeholder(),
        passwordFieldKey: GlobalKey<FormFieldState>(),
        passwordFieldController: TextEditingController(),
        passwordIcon: const Icon(Icons.key),
        passwordIsValidate: Validation.create(),

        // Login Submit
        loginSubmitWidget: const Placeholder(),
        signIn: AuthenticationServiceSignInUsecase(
                authenticationService: AuthenticationServiceFirebase(
                    instance: FirebaseAuth.instance))
            .execute,
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class SignInPageStateNotifier extends StateNotifier<SignInPageState> {
  SignInPageStateNotifier() : super(SignInPageState.create()) {
    rebuild();
  }

  // init
  void init() {
    state = SignInPageState.create();
  }

  // Rebuild
  void rebuild() {
    buildSignUpWidget();
    buildLoginIdField();
    buildPasswordField();
    buildLoginSubmitWidget();
  }

  void buildSignUpWidget() {
    final Widget widget = Builder(builder: (context) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: IconButton(
          onPressed: () {
            context.push('/signup');
          },
          icon: const Icon(Icons.person_add),
          tooltip: "新規登録",
        ),
      );
    });

    state = state.copyWith(singUpWidget: widget);
  }

  // Login Id Field
  void buildLoginIdField() {
    final Widget widget = Column(
      children: [
        TextFormField(
          key: state.loginIdFieldKey,
          controller: state.loginIdFieldController,
          onChanged: (text) {
            state.loginIdFieldKey.currentState!.validate();
            rebuild();
          },

          // 入力値の長さ制限
          maxLength: state.loginIdMaxLength,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(state.loginIdFieldName),

            // 入力フィールドの色・枠
            prefixIcon: state.loginIdIcon,

            // ヘルパー・エラーメッセージ表示
            counterText: "",
          ),

          // バリデーション
          validator: (value) {
            loginIdCustomValidator(value ?? "");
          },
        ),
        Text(
          state.loginIdIsValidate.message,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );

    state = state.copyWith(loginIdField: widget);
  }

  Validation loginIdCustomValidator(String value) {
    const defaultMessage = "";
    const emptyMessage = "";
    final minMaxLenghtMessage =
        "Min lenght: ${state.loginIdMinLength}, Max length : ${state.loginIdMaxLength}.";

    if (value.isEmpty) {
      final validation =
          Validation.create(isValid: false, message: emptyMessage);
      state = state.copyWith(loginIdIsValidate: validation);
      return validation;
    }

    if (value.length < state.loginIdMinLength) {
      final validation =
          Validation.create(isValid: false, message: minMaxLenghtMessage);
      state = state.copyWith(loginIdIsValidate: validation);
      return validation;
    }

    final validation =
        Validation.create(isValid: true, message: defaultMessage);

    state = state.copyWith(loginIdIsValidate: validation);
    return validation;
  }

  // Password Field
  void buildPasswordField() {
    // Passwordテキストフィールド
    final Widget widget = Column(
      children: [
        TextFormField(
          key: state.passwordFieldKey,
          controller: state.passwordFieldController,
          onChanged: (text) {
            state.passwordFieldKey.currentState!.validate();
            rebuild();
          },

          // 入力値の長さ制限
          maxLength: state.passwordMaxLength,

          // 入力値の表示・非表示
          obscureText: state.passwordIsObscure,

          // 入力フィールドの装飾
          decoration: InputDecoration(
            // フィールド名
            label: Text(state.passwordFieldName),

            // 入力フィールドの色・枠
            prefixIcon: state.passwordIcon,

            // passwordの表示・非表示切り替え
            suffixIcon: GestureDetector(
              onTap: () {
                passwordToggleObscureText();
                rebuild();
              },
              child: state.passwordIsObscure
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
            ),

            // ヘルパー・エラーメッセージ表示
            counterText: "",
          ),

          // バリデーション
          validator: (value) {
            passwordCustomValidator(value ?? "");
          },
        ),
        Text(state.passwordIsValidate.message,
            style: const TextStyle(color: Colors.red)),
      ],
    );

    state = state.copyWith(passwordField: widget);
  }

  void passwordToggleObscureText() {
    state = state.copyWith(passwordIsObscure: !state.passwordIsObscure);
  }

  Validation passwordCustomValidator(String value) {
    const defaultMessage = "";
    const emptyMessage = "";
    final minMaxLenghtMessage =
        "Min lenght: ${state.passwordMinLength}, Max length : ${state.passwordMaxLength}.";

    if (value.isEmpty) {
      final validation =
          Validation.create(isValid: false, message: emptyMessage);
      state = state.copyWith(passwordIsValidate: validation);
      return validation;
    }
    if (value.length < state.passwordMinLength) {
      final validation =
          Validation.create(isValid: false, message: minMaxLenghtMessage);
      state = state.copyWith(passwordIsValidate: validation);
      return validation;
    }
    final validation =
        Validation.create(isValid: true, message: defaultMessage);

    state = state.copyWith(passwordIsValidate: validation);
    return validation;
  }

  void buildLoginSubmitWidget() {
    final Widget widget = Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            )),
            onPressed: state.loginIdIsValidate.isValid &&
                    state.passwordIsValidate.isValid
                ? () {
                    final String email = state.loginIdFieldController.text;
                    final String password = state.passwordFieldController.text;
                    state.signIn(email, password);

                    init();
                  }
                : null,
            child: Text(state.loginSubmitWidgetName),
          ),
        ),
      ],
    );

    state = state.copyWith(loginSubmitWidget: widget);
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final signInPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<SignInPageStateNotifier, SignInPageState>(
  (ref) => SignInPageStateNotifier(),
);
