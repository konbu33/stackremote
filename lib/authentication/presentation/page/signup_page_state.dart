import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../usecase/current_user_send_verify_email.dart';
import '../../usecase/service_use_registration.dart';

import '../widget/password_field_state.dart';

class SignUpPageState {
  // --------------------------------------------------
  //
  //   loginIdFieldStateProvider
  //   passwordFieldStateProvider
  //   attentionMessageProvider
  //
  // --------------------------------------------------
  // static final loginIdFieldStateProvider =
  //     loginIdFieldStateNotifierProviderCreator();

  static final loginIdFieldStateNotifierProviderOfProvider =
      StateProvider.autoDispose((ref) {
    NameFieldStateNotifierProvider loginIdFieldStateNotifierProviderCreator() {
      const name = "メールアドレス";

      const minMax = MinMax(min: 8, max: 20);
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

    return loginIdFieldStateNotifierProviderCreator();
  });

  static final passwordFieldStateProviderOfProvider = StateProvider.autoDispose(
      (ref) => passwordFieldStateNotifierProviderCreator());

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

  // --------------------------------------------------
  //
  //  signUpOnSubmitButtonStateNotifierProvider
  //
  // --------------------------------------------------
  static const pageTitle = "サービス利用登録";

  static final signUpOnSubmitButtonStateNotifierProvider = Provider.autoDispose(
    (ref) {
      bool isOnSubmitable = false;

      final loginIdFieldStateNotifierProvider =
          ref.watch(loginIdFieldStateNotifierProviderOfProvider);

      final loginIdIsValidate = ref.watch(loginIdFieldStateNotifierProvider
          .select((value) => value.isValidate.isValid));

      final passwordFieldStateProvider =
          ref.watch(passwordFieldStateProviderOfProvider);

      final passwordIsValidate = ref.watch(passwordFieldStateProvider
          .select((value) => value.passwordIsValidate.isValid));

      void Function()? buildSignUpOnSubmit() {
        if (!isOnSubmitable) {
          return null;
        }

        return () async {
          final email = ref
              .read(loginIdFieldStateNotifierProvider)
              .textEditingController
              .text;

          final password =
              ref.read(passwordFieldStateProvider).passwordFieldController.text;

          try {
            // サービス利用登録
            final serviceUseRegistrationUsecase =
                ref.read(serviceUseRegistrationUsecaseProvider);

            await serviceUseRegistrationUsecase(email, password);

            // メールアドレス検証メール送信
            final currentUserSendVerifyEmailUsecase =
                ref.read(currentUserSendVerifyEmailUsecaseProvider);

            await currentUserSendVerifyEmailUsecase();

            //
          } on StackremoteException catch (e) {
            ref
                .read(attentionMessageStateProvider.notifier)
                .update((state) => e.message);
          }
        };
      }

      if (loginIdIsValidate && passwordIsValidate) {
        isOnSubmitable = true;
      }

      final signUpOnSubmitButtonStateNotifierProvider =
          onSubmitButtonStateNotifierProviderCreator(
        onSubmitButtonWidgetName: pageTitle,
        onSubmit: buildSignUpOnSubmit,
      );

      return signUpOnSubmitButtonStateNotifierProvider;
    },
  );
}
