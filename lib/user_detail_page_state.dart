// StateNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'authentication/presentation/widget/loginid_field_state.dart';
import 'authentication/presentation/widget/loginid_field_widget.dart';
import 'authentication/presentation/widget/password_field_state.dart';
import 'authentication/presentation/widget/password_field_widget.dart';
import 'authentication/presentation/widget/user_submit_state.dart';
import 'authentication/presentation/widget/user_submit_widget.dart';
import 'user_repository_firestore.dart';

import 'user_add_usecase.dart';
import 'user.dart';
import 'user_update_usecase.dart';

part 'user_detail_page_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class UserDetailPageState with _$UserDetailPageState {
  // Private Constructor
  const factory UserDetailPageState._({
    // Page Title
    required String pageTitle,
    required Widget pageTitleWidget,

    // Form
    required GlobalKey<FormState> userPageformValueKey,

    // Current User
    required User? currentUser,

    // User Name Field
    required Widget userNameField,
    required StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>
        loginIdFieldStateProvider,

    // Password Field
    required Widget passwordField,
    required StateNotifierProvider<PasswordFieldStateNotifier,
            PasswordFieldState>
        passwordFieldStateProvider,

    // User Add Button
    required Widget userAddButton,
    required UserAddUseCase userAddUseCase,
    required StateNotifierProvider<UserSubmitStateNotifier, UserSubmitState>
        userAddSubmitStateProvider,

    // User Update Button
    required Widget userUpdateButton,
    required UserUpdateUseCase userUpdateUseCase,
    required StateNotifierProvider<UserSubmitStateNotifier, UserSubmitState>
        userUpdateSubmitStateProvider,
  }) = _UserDetailPageState;

  // Factory Constructor
  factory UserDetailPageState.create() => UserDetailPageState._(
        // Page Title
        pageTitle: "User Page Detail",
        pageTitleWidget: const Placeholder(),

        // Form
        userPageformValueKey: GlobalKey<FormState>(),

        // Current User
        currentUser: null,

        // User Name Field
        userNameField: const Placeholder(),
        loginIdFieldStateProvider:
            StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>(
                (ref) {
          return LoginIdFieldStateNotifier();
        }),

        // Password Field
        passwordField: const Placeholder(),
        passwordFieldStateProvider: StateNotifierProvider<
            PasswordFieldStateNotifier, PasswordFieldState>((ref) {
          return PasswordFieldStateNotifier();
        }),

        // User Add Button
        userAddButton: const Placeholder(),
        userAddUseCase: UserAddUseCase(
            userRepository: UserRepositoryFireBase(
                firebaseFirestoreInstance: FirebaseFirestore.instance)),
        userAddSubmitStateProvider:
            StateNotifierProvider<UserSubmitStateNotifier, UserSubmitState>(
                (ref) {
          return UserSubmitStateNotifier(
            userSubmitWidgetName: "新規登録",
          );
        }),

        // User Update Button
        userUpdateButton: const Placeholder(),
        userUpdateUseCase: UserUpdateUseCase(
            userRepository: UserRepositoryFireBase(
                firebaseFirestoreInstance: FirebaseFirestore.instance)),
        userUpdateSubmitStateProvider:
            StateNotifierProvider<UserSubmitStateNotifier, UserSubmitState>(
                (ref) {
          return UserSubmitStateNotifier(
            userSubmitWidgetName: "ユーザ更新",
          );
        }),
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UserDetailPageStateController extends StateNotifier<UserDetailPageState> {
  UserDetailPageStateController({
    required this.ref,
  }) : super(UserDetailPageState.create()) {
    buildPageTitleWidget();
    buildUserNameField();
    buildPasswordField();
    buildUserAddButton();
    buildUserUpdateButton();
  }

  // ref
  final Ref ref;

  // Page Title
  void buildPageTitleWidget() {
    final Widget widget = Text(state.pageTitle);

    state = state.copyWith(pageTitleWidget: widget);
  }

  // User Name Field
  void buildUserNameField() {
    final Widget widget = LoginIdFieldWidget(
        loginIdFieldStateProvider: state.loginIdFieldStateProvider);

    state = state.copyWith(userNameField: widget);
  }

  // Password Field
  void buildPasswordField() {
    final Widget widget = PasswordFieldWidget(
        passwordFieldStateProvider: state.passwordFieldStateProvider);

    state = state.copyWith(passwordField: widget);
  }

  // User Add Button
  void buildUserAddButton() {
    final Widget widget = UserSubmitWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
      passwordFieldStateProvider: state.passwordFieldStateProvider,
      userSubmitStateProvider: state.userAddSubmitStateProvider,
    );

    state = state.copyWith(userAddButton: widget);
  }

  // User Update Button
  void buildUserUpdateButton() {
    final Widget widget = UserSubmitWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
      passwordFieldStateProvider: state.passwordFieldStateProvider,
      userSubmitStateProvider: state.userUpdateSubmitStateProvider,
    );

    state = state.copyWith(userUpdateButton: widget);
  }

  void setUserEmailAndPassword(User user) {
    // User Id Field Controller text set
    ref.read(state.loginIdFieldStateProvider.notifier).setUserEmail(user.email);
    // Password Field Controller text set
    ref
        .read(state.passwordFieldStateProvider.notifier)
        .setUserPassword(user.password);

    // currentUser set
    state = state.copyWith(currentUser: user);
  }

  void setUserAddOnSubmit() {
    // User Add Submit Function
    ref.read(state.userAddSubmitStateProvider.notifier).setOnSubmit(({
      required BuildContext context,
      required String email,
      required String password,
    }) {
      state.userAddUseCase.execute(email, password);

      ref.read(state.loginIdFieldStateProvider.notifier).initial();
      ref.read(state.passwordFieldStateProvider.notifier).initial();

      Navigator.pop(context);
    });
  }

  void setUserUpdateOnSubmit(User user) {
    // User Update Submit Function
    ref.read(state.userUpdateSubmitStateProvider.notifier).setOnSubmit(({
      required BuildContext context,
      required String email,
      required String password,
    }) {
      state.userUpdateUseCase.execute(user.userId, email, password);

      ref.read(state.loginIdFieldStateProvider.notifier).initial();
      ref.read(state.passwordFieldStateProvider.notifier).initial();

      Navigator.pop(context);
    });
  }

  void clearUserEmailAndPassword() {
    ref.read(state.loginIdFieldStateProvider.notifier).initial();
    ref.read(state.passwordFieldStateProvider.notifier).initial();
    state = state.copyWith(currentUser: null);
  }
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final userDetailPageStateControllerProvider =
    StateNotifierProvider<UserDetailPageStateController, UserDetailPageState>(
  (ref) => UserDetailPageStateController(ref: ref),
);
