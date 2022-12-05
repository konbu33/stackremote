import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../usecase/current_user_change_password.dart';
import '../widget/password_field_state.dart';
import '../widget/progress_state_change_password.dart';

class ChangePasswordPageState {
  // --------------------------------------------------
  //
  //  各password field の validation確認
  //
  // --------------------------------------------------
  static final checkPasswordIsValidateProvider = Provider.autoDispose((ref) {
    //

    bool checkPasswordIsValidate() {
      final passwordFieldStateProvider =
          ref.watch(passwordFieldStateProviderOfProvider);

      final passwordIsValidate = ref.watch(passwordFieldStateProvider
          .select((value) => value.passwordIsValidate.isValid));

      final passwordFieldConfirmStateProvider =
          ref.watch(passwordFieldConfirmStateProviderOfProvider);

      final passwordIsValidateConfirm = ref.watch(
          passwordFieldConfirmStateProvider
              .select((value) => value.passwordIsValidate.isValid));

      if (!passwordIsValidate) return false;
      if (!passwordIsValidateConfirm) return false;
      return true;
    }

    return checkPasswordIsValidate;
  });

  // --------------------------------------------------
  //
  //  複数password field 間の入力文字列の一致確認
  //
  // --------------------------------------------------
  static final checkPasswordIsMatchProvider = Provider.autoDispose((ref) {
    //

    bool checkPasswordIsMatch() {
      final passwordFieldStateProvider =
          ref.watch(passwordFieldStateProviderOfProvider);
      final passwordFieldState = ref.watch(passwordFieldStateProvider);

      final passwordFieldConfirmStateProvider =
          ref.watch(passwordFieldConfirmStateProviderOfProvider);

      final passwordFieldConfirmState =
          ref.watch(passwordFieldConfirmStateProvider);

      final passwordText = passwordFieldState.passwordFieldController.text;

      final passwordTextConfirm =
          passwordFieldConfirmState.passwordFieldController.text;

      if (passwordText != passwordTextConfirm) return false;
      return true;
    }

    return checkPasswordIsMatch;
  });

  // --------------------------------------------------
  //
  //   passwordFieldStateProvider
  //   passwordFieldConfirmStateProvider
  //
  // --------------------------------------------------

  static final passwordFieldStateProviderOfProvider = StateProvider.autoDispose(
      (ref) => passwordFieldStateNotifierProviderCreator());

  static final passwordFieldConfirmStateProviderOfProvider =
      StateProvider.autoDispose(
          (ref) => passwordFieldStateNotifierProviderCreator());

  // --------------------------------------------------
  //
  //   descriptionMessageStateProvider
  //   attentionMessageStateProvider
  //
  // --------------------------------------------------
  static final descriptionMessageStateProvider =
      StateProvider.autoDispose((ref) => "入力間違い防止のため、2回入力して下さい。");

  static final attentionMessageStateProvider = StateProvider.autoDispose((ref) {
    //

    // 個別PasswordField毎にvalidate確認
    final checkPasswordIsValidate = ref.watch(checkPasswordIsValidateProvider);
    final passwordIsValidate = checkPasswordIsValidate();

    if (!passwordIsValidate) return "";

    // 複数PasswordField間の入力値の一致確認
    final checkPasswordIsMatch = ref.watch(checkPasswordIsMatchProvider);
    final passwordIsMatch = checkPasswordIsMatch();

    if (!passwordIsMatch) {
      const String notMatchMessage = "入力したパスワードが不一致です。";
      return notMatchMessage;
    }

    return "";
  });

  // --------------------------------------------------
  //
  //  changePasswordProgressStateNotifierProviderOfProvider
  //
  // --------------------------------------------------
  static final changePasswordProgressStateNotifierProviderOfProvider =
      Provider((ref) {
    final function = ref.watch(progressStateChangePasswordProvider);

    return progressStateNotifierProviderCreator(function: function);
  });

// --------------------------------------------------
//
//   changePasswordOnSubmitButtonStateNotifierProvider
//
// --------------------------------------------------
  static const pageTitle = "パスワード変更";

  static final changePasswordOnSubmitButtonStateNotifierProvider =
      Provider.autoDispose((ref) {
    bool passwordIsValidate = false;
    bool passwordIsMatch = false;
    bool isOnSubmitable = false;

    final checkPasswordIsValidate = ref.watch(checkPasswordIsValidateProvider);
    final checkPasswordIsMatch = ref.watch(checkPasswordIsMatchProvider);

    // --------------------------------------------------
    //  onSubmit関数の生成
    // --------------------------------------------------
    void Function()? buildChangePasswordOnSubmit() {
      if (!isOnSubmitable) {
        return null;
      }

      return () async {
        final changePasswordProgressStateNotifierProvider =
            ref.read(changePasswordProgressStateNotifierProviderOfProvider);
        ref
            .read(changePasswordProgressStateNotifierProvider.notifier)
            .updateProgress();

        //
      };
    }

    passwordIsValidate = checkPasswordIsValidate();

    if (passwordIsValidate) {
      passwordIsMatch = checkPasswordIsMatch();
    }

    if (passwordIsMatch != isOnSubmitable) {
      isOnSubmitable = passwordIsMatch;
    }

    final changePasswordOnSubmitButtonStateNotifierProvider =
        onSubmitButtonStateNotifierProviderCreator(
      onSubmitButtonWidgetName: pageTitle,
      onSubmit: buildChangePasswordOnSubmit,
    );

    return changePasswordOnSubmitButtonStateNotifierProvider;
  });
}
