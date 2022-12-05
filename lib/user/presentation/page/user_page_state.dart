import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../domain/user.dart';
import '../widget/progress_state_update_user.dart';

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

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

  // --------------------------------------------------
  //
  //  updateUserProgressStateNotifierProviderOfProvider
  //
  // --------------------------------------------------
  static final updateUserProgressStateNotifierProviderOfProvider =
      Provider.autoDispose((ref) {
    final function = ref.watch(progressStateUpdateUserProvider);

    return progressStateNotifierProviderCreator(function: function);
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

    void Function()? buildUserUpdateOnSubmit() {
      if (!isOnSubmitable) {
        return null;
      }

      return () async {
        final updateUserProgressStateNotifierProvider =
            ref.read(updateUserProgressStateNotifierProviderOfProvider);

        ref
            .read(updateUserProgressStateNotifierProvider.notifier)
            .updateProgress();

        // final nickName = ref
        //     .read(nickNameFieldStateNotifierProvider)
        //     .textEditingController
        //     .text;

        // // ユーザ情報更新
        // final userStateNotifier = ref.read(userStateNotifierProvider.notifier);

        // userStateNotifier.setNickName(nickName);
      };
    }

    final userUpdateOnSubmitButtonStateNotifierProvider =
        onSubmitButtonStateNotifierProviderCreator(
      onSubmitButtonWidgetName: "$pageTitle更新",
      onSubmit: buildUserUpdateOnSubmit,
    );

    return userUpdateOnSubmitButtonStateNotifierProvider;
  });
}
