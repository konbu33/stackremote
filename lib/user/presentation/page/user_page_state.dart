import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../common/common.dart';
import '../../domain/user.dart';

import '../widget/nickname_field_state.dart';

class UserPageState {
  static const pageTitle = "ユーザ情報";

  static final nickNameFieldStateNotifierProvider =
      nickNameFieldStateNotifierProviderCreator();

  // --------------------------------------------------
  //
  // userUpdateOnSubmitButtonStateNotifierProvider
  //
  // --------------------------------------------------
  static final userUpdateOnSubmitButtonStateNotifierProvider =
      Provider.autoDispose((ref) {
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
          };
    }

    final userUpdateOnSubmitButtonStateNotifierProvider =
        onSubmitButtonStateNotifierProviderCreator(
      onSubmitButtonWidgetName: "$pageTitle更新",
      onSubmit: buildUserUpdateOnSubmit(),
    );

    return userUpdateOnSubmitButtonStateNotifierProvider;
  });
}
