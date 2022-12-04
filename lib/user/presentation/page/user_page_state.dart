import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:stackremote/common/validation/validator.dart';

import '../../../common/common.dart';
import '../../domain/user.dart';

class UserPageState {
  static const pageTitle = "ユーザ情報";

  // static final nickNameFieldStateNotifierProvider =
  //     nickNameFieldStateNotifierProviderCreator();

  static final nickNameFieldStateNotifierProviderOfProvider =
      StateProvider.autoDispose((ref) {
    NameFieldStateNotifierProvider nickNameFieldStateNotifierProviderCreator() {
      const name = "ニックネーム";

      const minMax = MinMax(min: 0, max: 20);
      final minMaxLenghtValidator =
          ref.watch(minMaxLenghtValidatorProvider(minMax));

      final nameFieldStateNotifierProvider =
          nameFieldStateNotifierProviderCreator(
        name: name,
        validator: minMaxLenghtValidator,
        minLength: minMax.min,
        maxLength: minMax.max,
      );

      return nameFieldStateNotifierProvider;
    }

    return nickNameFieldStateNotifierProviderCreator();
  });

  // --------------------------------------------------
  //
  // userUpdateOnSubmitButtonStateNotifierProvider
  //
  // --------------------------------------------------
  static final userUpdateOnSubmitButtonStateNotifierProvider =
      Provider.autoDispose((ref) {
    bool isOnSubmitable = false;

    final nickNameFieldStateNotifierProvider =
        ref.watch(nickNameFieldStateNotifierProviderOfProvider);

    final loginIdIsValidate = ref.watch(nickNameFieldStateNotifierProvider
        .select((value) => value.isValidate.isValid));

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
                .textEditingController
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
