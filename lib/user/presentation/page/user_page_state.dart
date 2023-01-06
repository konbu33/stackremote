import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/common.dart';
import '../../domain/nick_name.dart';

class UserPageState {
  static const pageTitle = "ユーザ情報";

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
        void updateUser() {
          final dateTimeNow =
              DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());

          void setMessage(String message) {
            ref
                .read(UserPageState.attentionMessageStateProvider.notifier)
                .update((state) => "$dateTimeNow: $message");
          }

          // --------------------------------------------------
          //
          // ユーザ情報更新
          //
          // --------------------------------------------------
          try {
            final nickNameFieldStateNotifierProvider = ref.read(
                UserPageState.nickNameFieldStateNotifierProviderOfProvider);

            final nickName = ref
                .read(nickNameFieldStateNotifierProvider)
                .textEditingController
                .text;

            // ユーザ情報更新
            ref.read(NickName.nickNameProvider.notifier).update((state) {
              final nickNameCreator =
                  ref.read(NickName.nickNameCreatorProvider);

              return nickNameCreator(nickName);
            });

            //
          } on StackremoteException catch (e) {
            setMessage(e.message);
          }

          //
        }

        updateUser();
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
