// StateNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:stackremote/user_repository_firestore.dart';

import 'user_add_usecase.dart';
import 'user.dart';
import 'user_update_usecase.dart';
import 'userid.dart';

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
    required ValueKey userPageformValueKey,

    // Current User
    required User? currentUser,

    // User Name Field
    required Widget userNameField,
    required ValueKey userNameFieldValueKey,
    required TextEditingController userNameFieldController,

    // Password Field
    required Widget passwordField,
    required ValueKey passwordFieldValueKey,
    required TextEditingController passwordFieldController,

    // User Add Button
    required String userAddButtonName,
    required Widget userAddButton,
    required ValueKey userAddButtonValueKey,
    required UserAddUseCase userAddUseCase,

    // User Update Button
    required String userUpdateButtonName,
    required Widget userUpdateButton,
    required ValueKey userUpdateButtonValueKey,
    required UserUpdateUseCase userUpdateUseCase,
  }) = _UserDetailPageState;

  // Factory Constructor
  factory UserDetailPageState.create() => UserDetailPageState._(
        // Page Title
        pageTitle: "User Page Detail",
        pageTitleWidget: const Placeholder(),

        // Form
        userPageformValueKey: const ValueKey("userpageform"),

        // Current User
        currentUser: null,

        // User Name Field
        userNameField: const Placeholder(),
        userNameFieldValueKey: const ValueKey("userNameField"),
        userNameFieldController: TextEditingController(),

        // Password Field
        passwordField: const Placeholder(),
        passwordFieldValueKey: const ValueKey("passwordField"),
        passwordFieldController: TextEditingController(),

        // User Add Button
        userAddButton: const Placeholder(),
        userAddButtonValueKey: const ValueKey("userAddButton"),
        userAddButtonName: "新規登録",
        userAddUseCase: UserAddUseCase(
            userRepository: UserRepositoryFireBase(
                firebaseFirestoreInstance: FirebaseFirestore.instance)),

        // User Update Button
        userUpdateButton: const Placeholder(),
        userUpdateButtonValueKey: const ValueKey("userUpdateButton"),
        userUpdateButtonName: "ユーザ更新",
        userUpdateUseCase: UserUpdateUseCase(
            userRepository: UserRepositoryFireBase(
                firebaseFirestoreInstance: FirebaseFirestore.instance)),
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UserDetailPageStateController extends StateNotifier<UserDetailPageState> {
  UserDetailPageStateController() : super(UserDetailPageState.create()) {
    buildPageTitleWidget();
    buildUserNameField();
    buildPasswordField();
    buildUserAddButton();
    buildUserUpdateButton();
  }

  // Page Title
  void buildPageTitleWidget() {
    final Widget widget = Text(state.pageTitle);

    state = state.copyWith(pageTitleWidget: widget);
  }

  // User Name Field
  void buildUserNameField() {
    final Widget widget = TextFormField(
      key: state.userNameFieldValueKey,
      controller: state.userNameFieldController,
      onChanged: (String text) {
        rebuild();
      },
    );

    state = state.copyWith(userNameField: widget);
  }

  // Password Field
  void buildPasswordField() {
    final Widget widget = TextFormField(
      key: state.passwordFieldValueKey,
      controller: state.passwordFieldController,
      onChanged: (String text) {
        rebuild();
      },
    );

    state = state.copyWith(passwordField: widget);
  }

  // User Add Button
  void buildUserAddButton() {
    final Widget widget = Builder(builder: (context) {
      return ElevatedButton(
        key: state.userAddButtonValueKey,
        onPressed: () {
          final String email = state.userNameFieldController.text;
          final String password = state.passwordFieldController.text;
          state.userAddUseCase.execute(email, password);

          clearUserEmailAndPassword();
          Navigator.pop(context);
        },
        child: Text(state.userAddButtonName),
      );
    });

    state = state.copyWith(userAddButton: widget);
  }

  // User Update Button
  void buildUserUpdateButton() {
    final Widget widget = Builder(builder: (context) {
      return ElevatedButton(
        key: state.userUpdateButtonValueKey,
        onPressed: () {
          final currentUser = state.currentUser;
          if (currentUser != null) {
            // final String userId = currentUser.userId.value.toString();
            final UserId userId = currentUser.userId;
            final String email = state.userNameFieldController.text;
            final String password = state.passwordFieldController.text;
            state.userUpdateUseCase.execute(userId, email, password);
          }

          clearUserEmailAndPassword();
          Navigator.pop(context);
        },
        child: Text(state.userUpdateButtonName),
      );
    });

    state = state.copyWith(userUpdateButton: widget);
  }

  void setUserEmailAndPassword(User user) {
    state.userNameFieldController.text = user.email;
    state.passwordFieldController.text = user.password;
    state = state.copyWith(currentUser: user);
  }

  void clearUserEmailAndPassword() {
    state.userNameFieldController.clear();
    state.passwordFieldController.clear();
    state = state.copyWith(currentUser: null);
  }

  // Rebuild
  void rebuild() {
    state = state.copyWith();
    print(" ---------- rebuild !!! ---------- ");
  }
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final userDetailPageStateControllerProvider =
    StateNotifierProvider<UserDetailPageStateController, UserDetailPageState>(
  (ref) => UserDetailPageStateController(),
);
