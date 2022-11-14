import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nested/nested.dart';

import 'authentication/authentication.dart';
import 'common/common.dart';
import 'menu/menu.dart';

// improve:　このlayerはauthentication側に凝集した方が良い可能性あり。
class AuthenticationLayer extends SingleChildStatelessWidget {
  const AuthenticationLayer({
    Key? key,
    Widget? child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer(
      child: child,
      builder: (context, ref, child) {
        // 認証状況の変移をwatch開始
        final authenticationServiceAuthStateChangesUsecase =
            ref.watch(authenticationServiceAuthStateChangesUsecaseProvider);
        authenticationServiceAuthStateChangesUsecase();

        // 認証されたユーザの情報のisSignIn属性をwatch開始
        final isSignIn = ref.watch(firebaseAuthUserStateNotifierProvider
            .select((value) => value.isSignIn));

        // 認証されたユーザの情報のemailVefiried属性をwatch開始
        final isEmailVerified = ref.watch(firebaseAuthUserStateNotifierProvider
            .select((value) => value.emailVerified));

        final firebaseAuthUser =
            ref.watch(firebaseAuthUserStateNotifierProvider);
        logger.d(firebaseAuthUser);

        // 「サインイン済み、かつ、メールアドレス検証済み」の場合、Menuのルーティングへ移行。
        // 「サインイン済み、かつ、メールアドレス検証済み」でない場合、Authenticationのルーティングへ移行。
        return isSignIn && isEmailVerified
            ? const MenuRoutingLayer()
            : const AuthenticationRoutingLayer();
      },
    );
  }
}
