import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../common/create_firebse_auth_exception_message.dart';
import '../../usecase/current_user_send_verify_email.dart';
import '../../usecase/service_signout.dart';

import '../widget/login_submit_state.dart';

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

  // static final descriptionMessageStateProvider =
  //     descriptionMessageStateProviderCreator(
  //         message: message.replaceAll(" ", ""));

  static final descriptionMessageStateProvider =
      StateProvider.autoDispose((ref) => message.replaceAll(" ", ""));

  // --------------------------------------------------
  //
  //   signOutIconStateProvider
  //
  // --------------------------------------------------
  static final signOutIconStateProvider = Provider((ref) {
    //

    void Function() buildSignOutIconOnSubmit() {
      return () async {
        final serviceSignOutUsecase = ref.read(serviceSignOutUsecaseProvider);

        await serviceSignOutUsecase();
      };
    }

    final appbarActionIconState = AppbarActionIconState.create(
      onSubmitWidgetName: "サインアウト",
      icon: const Icon(Icons.logout),
      onSubmit: buildSignOutIconOnSubmit,
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
  // static final attentionMessageStateProvider =
  //     descriptionMessageStateProviderCreator();

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

// --------------------------------------------------
//
//   onSubmitStateProvider
//
// --------------------------------------------------
  static final onSubmitStateProvider = Provider.autoDispose((ref) {
    // final attentionMessageStateNotifier =
    //     ref.watch(attentionMessageStateProvider.notifier);

    // --------------------------------------------------
    //  onSubmit関数の生成
    // --------------------------------------------------
    Function? buildSendVerifyMailOnSubmit() {
      return ({
        required BuildContext context,
      }) =>
          () async {
            try {
              // メールアドレス検証メール送信
              final currentUserSendVerifyEmailUsecase =
                  ref.read(currentUserSendVerifyEmailUsecaseProvider);

              await currentUserSendVerifyEmailUsecase();

              const String message = "メール再送しました。";
              ref
                  .read(attentionMessageStateProvider.notifier)
                  .update((state) => message);
              //

            } on firebase_auth.FirebaseAuthException catch (e) {
              logger.d("$e");

              final createFirebaseExceptionMessage =
                  ref.read(createFirebaseAuthExceptionMessageProvider);

              final String message = createFirebaseExceptionMessage(e);
              ref
                  .read(attentionMessageStateProvider.notifier)
                  .update((state) => message);
            }
          };
    }

    final onSubmitStateProvider = loginSubmitStateNotifierProviderCreator(
      loginSubmitWidgetName: "メール再送信",
      onSubmit: buildSendVerifyMailOnSubmit(),
    );

    return onSubmitStateProvider;
  });
}
