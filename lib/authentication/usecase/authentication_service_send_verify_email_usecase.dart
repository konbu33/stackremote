import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';

final authenticationServiceSendVerifyEmailUsecaseProvider = Provider((ref) {
  //

  void execute({
    required firebase_auth.User user,
  }) {
    logger.d("start : sendVerifyEmail");
    if (!user.emailVerified) {
      user.sendEmailVerification();
      logger.d("end : sendVerifyEmail : メールアドレス未検証だったため、メール送信しました。");
    }
    logger.d("end: sendVerifyEmail : 既にメールアドレス検証済みだたっため、メール送信しませんでした。");
  }

  return execute;
});
