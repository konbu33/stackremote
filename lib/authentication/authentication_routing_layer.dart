import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/common.dart';
import 'domain/firebase_auth_user.dart';
import 'presentation/page/signin_page.dart';
import 'presentation/page/signin_page_state.dart';
import 'presentation/page/signup_page.dart';
import 'presentation/page/wait_email_verified_page.dart';

class AuthenticationRoutingLayer extends HookConsumerWidget {
  const AuthenticationRoutingLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(authenticationRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // go_router設定
      // improve: go_router 5.0以降は、routerConfig属性でまとめて設設可能そう。
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,

      // NestedLayerの最深部にchildとしてルーティング先を配置
      builder: (context, child) {
        return child == null
            ? const Text("Child null")
            : DesignNestedLayer(child: child);
      },
    );
  }
}

// --------------------------------------------------
//
// go_router
//
// --------------------------------------------------
final authenticationRouterProvider = Provider(
  (ref) {
    // improve：肥大化しそうなため、分割を検討
    return GoRouter(
      // デフォルト表示されるルーティング先
      initialLocation: '/signin',

      // ルーティング先
      // improve：ルーティング先をグループ化してコンポーネント化し、着脱容易にしたい。
      routes: [
        // デフォルト表示
        GoRoute(path: '/', builder: (context, state) => const SignInPage()),

        // サインイン・サインアップ
        GoRoute(
            path: '/signin',
            builder: (context, state) => const SignInPage(),
            redirect: (state) {
              final isSignUpPagePush =
                  ref.watch(SignInPageState.isSignUpPagePushProvider);
              if (isSignUpPagePush) return '/signin/signup';
              return null;
            },
            routes: [
              GoRoute(
                  path: 'signup',
                  builder: (context, state) => const SignUpPage()),
            ]),
        GoRoute(
            path: '/wait_mail_verified',
            builder: (context, state) => const WaitEmailVerifiedPage()),
      ],

      // リダイレクト設定
      // improve：if文での分岐を抽象化したい。
      redirect: (state) {
        // 「本アプリ側のログイン状態 + メールアドレス検証済・未検証」をwatch。
        // 本アプリ側のログイン状態が変化したら、ルーティングに反映される。
        final isSignIn = ref.watch(firebaseAuthUserStateNotifierProvider
            .select((value) => value.isSignIn));

        final isEmailVerified = ref.watch(firebaseAuthUserStateNotifierProvider
            .select((value) => value.emailVerified));

        // サインイン済み & メールアドレス未検証の場合のリダイレクト動作
        if (isSignIn) {
          if (!isEmailVerified) {
            if (state.subloc == '/wait_mail_verified') {
              return null;
            } else {
              return '/wait_mail_verified';
            }
          }
        }
        return null;
      },
    );
  },
);
