// StateNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'authentication/presentation/widget/loginid_field_state.dart';
import 'authentication/presentation/widget/password_field_state.dart';
import 'authentication/presentation/widget/user_submit_state.dart';
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

    // Form
    required GlobalKey<FormState> userPageformValueKey,

    // Current User
    required User? currentUser,

    // User Name Field
    required StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>
        loginIdFieldStateProvider,

    // Password Field
    required StateNotifierProvider<PasswordFieldStateNotifier,
            PasswordFieldState>
        passwordFieldStateProvider,

    // User Add Button
    required UserAddUseCase userAddUseCase,
    required UserSubmitStateProvider userAddSubmitStateProvider,

    // User Update Button
    required UserUpdateUseCase userUpdateUseCase,
    required UserSubmitStateProvider userUpdateSubmitStateProvider,
  }) = _UserDetailPageState;

  // Factory Constructor
  factory UserDetailPageState.create() => UserDetailPageState._(
        // Page Title
        pageTitle: "User Page Detail",

        // Form
        userPageformValueKey: GlobalKey<FormState>(),

        // Current User
        currentUser: null,

        // User Name Field
        loginIdFieldStateProvider: loginIdFieldStateNotifierProviderCreator(),

        // Password Field
        passwordFieldStateProvider: passwordFieldStateNotifierProviderCreator(),

        // User Add Button
        userAddUseCase: UserAddUseCase(
            userRepository: UserRepositoryFireBase(
                firebaseFirestoreInstance: FirebaseFirestore.instance)),

        userAddSubmitStateProvider: userSubmitStateNotifierProviderCreator(
          userSubmitWidgetName: "新規登録",
          onSubmit: () {},
        ),

        // User Update Button
        userUpdateUseCase: UserUpdateUseCase(
            userRepository: UserRepositoryFireBase(
                firebaseFirestoreInstance: FirebaseFirestore.instance)),

        userUpdateSubmitStateProvider: userSubmitStateNotifierProviderCreator(
          userSubmitWidgetName: "ユーザ更新",
          onSubmit: () {},
        ),
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
  }) : super(UserDetailPageState.create());

  // ref
  final Ref ref;

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
