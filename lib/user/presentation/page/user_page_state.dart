// StateNotifier
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart';

import '../../../authentication/authentication.dart';

import '../../domain/user.dart';

import '../widget/nickname_field_state.dart';

part 'user_page_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class UserPageState with _$UserPageState {
  // Private Constructor
  const factory UserPageState._({
    // Page Title
    required String pageTitle,

    // Form
    required GlobalKey<FormState> userPageformValueKey,

    // User Name Field
    required NickNameFieldStateNotifierProvider
        nickNameFieldStateNotifierProvider,

    // User Update Button
    // required UserUpdateUsecase userUpdateUsecase,
    required LoginSubmitStateProvider userUpdateSubmitStateProvider,

    // ignore: unused_element
    @Default(false) bool isOnSubmitable,
  }) = _UserPageState;

  // Factory Constructor
  factory UserPageState.create() => UserPageState._(
        // Page Title
        pageTitle: "ユーザ情報",

        // Form
        userPageformValueKey: GlobalKey<FormState>(),

        // User Name Field
        nickNameFieldStateNotifierProvider:
            nickNameFieldStateNotifierProviderCreator(),

        userUpdateSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
          loginSubmitWidgetName: "ユーザ更新",
          onSubmit: null,
        ),
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UserPageStateController extends StateNotifier<UserPageState> {
  UserPageStateController({
    required this.ref,
  }) : super(UserPageState.create());

  // ref
  final Ref ref;

  void updateIsOnSubmitable(bool isOnSubmitable) {
    state = state.copyWith(isOnSubmitable: isOnSubmitable);
  }

  void setUserUpdateOnSubmit() {
    Function? buildOnSubmit() {
      if (!state.isOnSubmitable) {
        return null;
      }

      return ({
        required BuildContext context,
      }) =>
          () {
            final nickName = ref
                .read(state.nickNameFieldStateNotifierProvider)
                .nickNameFieldController
                .text;

            // ユーザ情報更新
            final notifier = ref.read(userStateNotifierProvider.notifier);
            notifier.setNickName(nickName);

            ref
                .read(state.nickNameFieldStateNotifierProvider.notifier)
                .initial();
          };
    }

    state = state.copyWith(
      userUpdateSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
        loginSubmitWidgetName: "ユーザ更新",
        onSubmit: buildOnSubmit(),
      ),
    );
  }
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final userPageStateControllerProvider =
    StateNotifierProvider<UserPageStateController, UserPageState>(
  (ref) => UserPageStateController(ref: ref),
);
