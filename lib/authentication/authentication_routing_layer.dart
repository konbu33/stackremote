// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:stackremote/authentication/infrastructure/authentication_service_firebase.dart';
import 'package:stackremote/authentication/presentation/page/wait_email_verified_page.dart';
// import 'package:stackremote/authentication/usecase/authentication_service_get_id_token_usecase.dart';

// import 'infrastructure/auth_state_changes_provider.dart';
import '../common/common.dart';
import 'domain/firebase_auth_user.dart';
import 'presentation/page/signin_page.dart';
import 'presentation/page/signup_page.dart';

class AuthenticationRoutingLayer extends HookConsumerWidget {
  const AuthenticationRoutingLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // go_router設定
      // go_router 5.0以降は、routerConfig属性でまとめて設設可能そう。
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

final routerProvider = Provider(
  (ref) {
    // improve：肥大化しそうなため、分割を検討
    return GoRouter(
      // デフォルト表示されるルーティング先
      initialLocation: '/',

      // NestedLayerの最深部にchildとしてルーティング先を配置
      // improve: navigatorBuilderでネストするこの設計は、
      // go_routerのnavigatorBuilderを知っていないと、
      // 理解できないので、他の方法で代替可能か検討の余地あり。
      navigatorBuilder: (context, state, child) {
        return DesignNestedLayer(child: child);
      },

      // ルーティング先
      // improve：ルーティング先をグループ化してコンポーネント化し、着脱容易にしたい。
      routes: [
        // デフォルト表示
        GoRoute(path: '/', builder: (context, state) => const SignInPage()),

        // サインイン・サインアップ
        GoRoute(
            path: '/signin', builder: (context, state) => const SignInPage()),
        GoRoute(
            path: '/signup', builder: (context, state) => const SignUpPage()),
        GoRoute(
            path: '/waitmailverified',
            builder: (context, state) => const WaitEmailVerifiedPage()),
        // GoRoute(
        //   path: '/waitmailverified',
        //   builder: (context, state) {
        //     return Navigator(
        //       onPopPage: (route, result) {
        //         if (!route.didPop(result)) {
        //           return false;
        //         }
        //         return true;
        //       },
        //       pages: const [
        //         MaterialPage(child: SignInPage()),
        //         MaterialPage(child: WaitEmailVerifiedPage()),
        //       ],
        //     );
        //   },
        // ),
      ],

      // リダイレクト設定
      // improve：if文での分岐を抽象化したい。
      redirect: (state) {
        // Firebase Authentication側のログイン状態をwatch。
        // Firebase Authentication側のログイン状態が変化したら、本アプリ側のログイン状態に反映される。
        // ref.read(authStateChangesProvider);

        // Firebase AuthenticationのToken取得
        // ref.read(firebaseAuthGetIdTokenProvider);

        // 「本アプリ側のログイン状態 + メールアドレス検証済・未検証」をwatch。
        // 本アプリ側のログイン状態が変化したら、ルーティングに反映される。
        final isSignIn = ref.watch(firebaseAuthUserStateNotifierProvider
            .select((value) => value.isSignIn));

        final isEmailVerified = ref.watch(firebaseAuthUserStateNotifierProvider
            .select((value) => value.emailVerified));

        // // サインイン済み & メールアドレス未検証の場合のリダイレクト動作
        if (isSignIn) {
          if (!isEmailVerified) {
            if (state.subloc == '/waitmailverified') {
              return null;
            } else {
              return '/waitmailverified';
            }
          }
        }
        return null;

        // // サインイン済み & メールアドレス未検証の場合のリダイレクト動作
        // if (isSignIn) {
        //   if (isEmailVerified) {
        //     if (state.subloc == '/agoravideochanneljoin') {
        //       return null;
        //     } else {
        //       return '/agoravideochanneljoin';
        //     }
        //   } else {
        //     if (state.subloc == '/waitmailverified') {
        //       return null;
        //     } else {
        //       return '/waitmailverified';
        //     }
        //   }
        // }

        // // 未サインインの場合のリダイレクト動作
        // if (!isSignIn) {
        //   if (state.subloc == '/') {
        //     return '/signin';
        //   } else if (state.subloc == '/signin') {
        //     return null;
        //   } else if (state.subloc == '/signup') {
        //     return null;
        //   } else {
        //     return '/signin';
        //   }
        // } else {
        //   if (state.subloc == '/') {
        //     return null;
        //   } else if (state.subloc == '/signin') {
        //     return '/';
        //   } else if (state.subloc == '/signup') {
        //     return '/';
        //   } else {
        //     return null;
        //   }
        // }
      },
    );
  },
);
