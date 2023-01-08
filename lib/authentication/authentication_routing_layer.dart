import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/common.dart';

import 'domain/firebase_auth_user.dart';
import 'presentation/page/signin_page.dart';
import 'presentation/page/signup_page.dart';
import 'presentation/page/wait_email_verified_page.dart';

class AuthenticationRoutingLayer extends ConsumerWidget {
  const AuthenticationRoutingLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(authenticationRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // go_router設定
      routerConfig: router,

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
// AuthenticationRoutingPath
//
// --------------------------------------------------
enum AuthenticationRoutingPath {
  signIn(path: '/signin'),
  signUp(path: 'signup'),
  signInSignUp(path: '/signin/signup'),
  waitMailVerified(path: '/wait_mail_verified');

  const AuthenticationRoutingPath({
    required this.path,
  });

  final String path;
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
      initialLocation: AuthenticationRoutingPath.signIn.path,

      // ルーティング先
      // improve：ルーティング先をグループ化してコンポーネント化し、着脱容易にしたい。
      routes: [
        // サインイン・サインアップ
        GoRoute(
            path: AuthenticationRoutingPath.signIn.path,
            builder: (context, state) => const SignInPage(),
            routes: [
              GoRoute(
                  path: AuthenticationRoutingPath.signUp.path,
                  builder: (context, state) => const SignUpPage()),
            ]),
        GoRoute(
            path: AuthenticationRoutingPath.waitMailVerified.path,
            builder: (context, state) => const WaitEmailVerifiedPage()),
      ],

      // リダイレクト設定
      redirect: (context, state) {
        // 「本アプリ側のログイン状態 + メールアドレス検証済・未検証」をwatch。
        // 本アプリ側のログイン状態が変化したら、ルーティングに反映される。
        final isSignIn = ref.watch(firebaseAuthUserStateNotifierProvider
            .select((value) => value.isSignIn));

        final isEmailVerified = ref.watch(firebaseAuthUserStateNotifierProvider
            .select((value) => value.emailVerified));

        // サインイン済み & メールアドレス検証済の場合、上位のWidgetでrouter自体を切り替えて画面遷移している。
        // サインイン済み & メールアドレス未検証の場合のリダイレクト動作
        if (isSignIn) {
          if (!isEmailVerified) {
            return AuthenticationRoutingPath.waitMailVerified.path;
          }
        }

        // 未サインイン & メールアドレス未検証の場合、
        // context.goなどで明示的に指定された場合、指定された先へ遷移(例えば、signUp)。
        // 未指定の場合、initialLocation へ遷移。
        return null;
      },
    );
  },
);
