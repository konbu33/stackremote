// StateNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'authentication/presentation/widget/loginid_field_state.dart';
import 'authentication/presentation/widget/password_field_state.dart';
import 'authentication/presentation/widget/login_submit_state.dart';
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
    required LoginIdFieldStateProvider loginIdFieldStateProvider,

    // Password Field
    required PasswordFieldStateProvider passwordFieldStateProvider,

    // User Add Button
    required UserAddUseCase userAddUseCase,
    required LoginSubmitStateProvider userAddSubmitStateProvider,

    // User Update Button
    required UserUpdateUseCase userUpdateUseCase,
    required LoginSubmitStateProvider userUpdateSubmitStateProvider,
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

        userAddSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
          loginSubmitWidgetName: "新規登録",
          onSubmit: () {},
        ),

        // User Update Button
        userUpdateUseCase: UserUpdateUseCase(
            userRepository: UserRepositoryFireBase(
                firebaseFirestoreInstance: FirebaseFirestore.instance)),

        userUpdateSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
          loginSubmitWidgetName: "ユーザ更新",
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
    Function buildOnSubmit() {
      return ({
        required BuildContext context,
      }) {
        final email = ref
            .read(state.loginIdFieldStateProvider)
            .loginIdFieldController
            .text;
        final password = ref
            .read(state.passwordFieldStateProvider)
            .passwordFieldController
            .text;

        // ユーザ情情追加
        state.userAddUseCase.execute(email, password);

        // 戻る
        Navigator.pop(context);
      };
    }

    state = state.copyWith(
        userAddSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
      loginSubmitWidgetName: "新規登録",
      onSubmit: buildOnSubmit(),
    ));
  }

  void setUserUpdateOnSubmit(User user) {
    Function buildOnSubmit() {
      return ({
        required BuildContext context,
      }) {
        final userId = user.userId;
        final email = ref
            .read(state.loginIdFieldStateProvider)
            .loginIdFieldController
            .text;
        final password = ref
            .read(state.passwordFieldStateProvider)
            .passwordFieldController
            .text;

        // ユーザ情情更新
        state.userUpdateUseCase.execute(userId, email, password);

        // 戻る
        Navigator.pop(context);
      };
    }

    state = state.copyWith(
      userUpdateSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
        loginSubmitWidgetName: "ユーザ更新",
        onSubmit: buildOnSubmit(),
      ),
    );
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
