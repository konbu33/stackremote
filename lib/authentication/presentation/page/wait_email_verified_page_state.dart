import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/progress_state_send_verify_email.dart';
import '../widget/progress_state_signout.dart';

class WaitEmailVerifiedPageState {
  static const pageTitle = "メールアドレス確認待ち";

  static const String message = ''' 
    あなたが「サービス利用登録時に登録したメールアドレス」の持ち主かどうか、確認待ちの状態です。
    \n
    「サービス利用登録時に登録したメールアドレス」へ、メールを送信しました。
    メール本文のリンクをクリックし、あなたがメールアドレスの持ち主であことを証明して下さい。
    \n
    もし、メールが届いていない場合、下記からメールを再送信可能です。
  ''';

  static final descriptionMessageStateProvider =
      StateProvider.autoDispose((ref) => message.replaceAll(" ", ""));

  // --------------------------------------------------
  //
  //  sendVerifyEmailProgressStateNotifierProviderOfProvider
  //
  // --------------------------------------------------
  static final sendVerifyEmailProgressStateNotifierProviderOfProvider =
      Provider((ref) {
    final function = ref.watch(progressStateSendVerifyEmailProvider);

    return progressStateNotifierProviderCreator(function: function);
  });

  // --------------------------------------------------
  //
  //  signOutProgressStateNotifierProviderOfProvider
  //
  // --------------------------------------------------
  static final signOutProgressStateNotifierProviderOfProvider = Provider((ref) {
    final function = ref.watch(progressStateSignOutProvider);

    return progressStateNotifierProviderCreator(function: function);
  });

  // --------------------------------------------------
  //
  //   signOutIconStateProvider
  //
  // --------------------------------------------------
  static final signOutIconStateProvider = Provider((ref) {
    //

    AppbarActionIconOnSubmitFunction buildSignOutIconOnSubmit() {
      return ({required BuildContext context}) => () async {
            final signOutProgressStateNotifierProvider =
                ref.read(signOutProgressStateNotifierProviderOfProvider);

            ref
                .read(signOutProgressStateNotifierProvider.notifier)
                .updateProgress();
          };
    }

    final appbarActionIconState = AppbarActionIconState.create(
      onSubmitWidgetName: "サインアウト",
      icon: const Icon(Icons.logout),
      onSubmit: buildSignOutIconOnSubmit(),
    );

    final signOutIconStateProvider =
        appbarActionIconStateNotifierProviderCreator(
      appbarActionIconState: appbarActionIconState,
    );

    return signOutIconStateProvider;
  });

  // --------------------------------------------------
  //
  //   attentionMessageStateProvider
  //
  // --------------------------------------------------

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

  // --------------------------------------------------
  //
  //   onSubmitStateProvider
  //
  // --------------------------------------------------
  static final sendVerifyEmailOnSubmitStateNotifierProvider =
      Provider.autoDispose((ref) {
    // --------------------------------------------------
    //  onSubmit関数の生成
    // --------------------------------------------------
    void Function()? buildSendVerifyMailOnSubmit() {
      return () async {
        final sendVerifyEmailProgressStateNotifierProvider =
            ref.read(sendVerifyEmailProgressStateNotifierProviderOfProvider);
        ref
            .read(sendVerifyEmailProgressStateNotifierProvider.notifier)
            .updateProgress();
      };
    }

    final sendVerifyEmailOnSubmitStateNotifierProvider =
        onSubmitButtonStateNotifierProviderCreator(
      onSubmitButtonWidgetName: "メール再送信",
      onSubmit: buildSendVerifyMailOnSubmit,
    );

    return sendVerifyEmailOnSubmitStateNotifierProvider;
  });
}
