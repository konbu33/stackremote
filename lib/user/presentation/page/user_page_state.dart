import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../authentication/authentication.dart';

import '../../domain/user.dart';

import '../widget/nickname_field_state.dart';

class UserPageState {
  const UserPageState();

  static const pageTitle = "ユーザ情報";

  static final nickNameFieldStateNotifierProvider =
      nickNameFieldStateNotifierProviderCreator();

  // --------------------------------------------------
  //
  // userUpdateSubmitStateProvider
  //
  // --------------------------------------------------
  static final userUpdateSubmitStateProvider = Provider.autoDispose((ref) {
    bool isOnSubmitable = false;

    final loginIdIsValidate = ref.watch(nickNameFieldStateNotifierProvider
        .select((value) => value.nickNameIsValidate.isValid));

    if (loginIdIsValidate != isOnSubmitable) {
      isOnSubmitable = loginIdIsValidate;
    }

    Function? buildUserUpdateOnSubmit() {
      if (!isOnSubmitable) {
        return null;
      }

      return ({
        required BuildContext context,
      }) =>
          () {
            final nickName = ref
                .read(nickNameFieldStateNotifierProvider)
                .nickNameFieldController
                .text;

            // ユーザ情報更新
            final userStateNotifier =
                ref.read(userStateNotifierProvider.notifier);

            userStateNotifier.setNickName(nickName);

            // ref.read(nickNameFieldStateNotifierProvider.notifier).initial();
          };
    }

    final userUpdateSubmitStateProvider =
        loginSubmitStateNotifierProviderCreator(
      loginSubmitWidgetName: pageTitle,
      onSubmit: buildUserUpdateOnSubmit(),
    );

    return userUpdateSubmitStateProvider;
  });
}
