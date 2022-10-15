import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/common.dart';
import 'presentation/page/user_detail_page.dart';
import 'presentation/page/user_page.dart';

class UserRoutingLayer extends HookConsumerWidget {
  const UserRoutingLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(userRouterProvider);

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

// --------------------------------------------------
//
// go_router
//
// --------------------------------------------------
final userRouterProvider = Provider(
  (ref) {
    // improve：肥大化しそうなため、分割を検討
    return GoRouter(
      // デフォルト表示されるルーティング先
      initialLocation: '/',

      // // NestedLayerの最深部にchildとしてルーティング先を配置
      // // improve: navigatorBuilderでネストするこの設計は、
      // // go_routerのnavigatorBuilderを知っていないと、
      // // 理解できないので、他の方法で代替可能か検討の余地あり。
      // navigatorBuilder: (context, state, child) {
      //   return DesignNestedLayer(child: child);
      // },

      // ルーティング先
      // improve：ルーティング先をグループ化してコンポーネント化し、着脱容易にしたい。
      routes: [
        //  デフォルト表示
        GoRoute(path: '/', builder: (context, state) => const UserPage()),

        // RTC 関連
        GoRoute(path: '/user', builder: (context, state) => const UserPage()),
        GoRoute(
            path: '/userdetail',
            builder: (context, state) => const UserDetailPage()),
      ],

      // // リダイレクト設定
      // // improve：if文での分岐を抽象化したい。
      // redirect: (state) {
      //   // rtc channel join済・未joinの状態監視
      //   final RtcChannelState rtcChannelState = ref.watch(
      //       RtcChannelStateNotifierProviderList
      //           .rtcChannelStateNotifierProvider);

      //   // サインイン済み & メールアドレス検証済みの場合のリダイレクト動作
      //   // rtc channel join済・未joinの状態を監視し、
      //   // 状態が変化した場合、リダイレクト操作が実施される。
      //   if (rtcChannelState.joined) {
      //     if (state.subloc == '/agoravideo') {
      //       return null;
      //     } else {
      //       return '/agoravideo';
      //     }
      //   } else {
      //     if (state.subloc == '/agoravideochanneljoin') {
      //       return null;
      //     } else {
      //       return '/agoravideochanneljoin';
      //     }
      //   }
      // },
    );
  },
);
