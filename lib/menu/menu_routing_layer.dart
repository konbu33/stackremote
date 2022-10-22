import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/rtc_video/presentation/page/agora_video_channel_join_page.dart';
import 'package:stackremote/rtc_video/presentation/page/agora_video_page.dart';

import '../authentication/authentication.dart';
import '../common/common.dart';
import '../rtc_video/domain/rtc_channel_state.dart';
import '../user/user.dart';

class MenuRoutingLayer extends HookConsumerWidget {
  const MenuRoutingLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(menuRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // go_router設定
      // go_router 5.0以降は、routerConfig属性でまとめて設設可能そう。
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
final menuRouterProvider = Provider(
  (ref) {
    // improve：肥大化しそうなため、分割を検討
    return GoRouter(
      // デフォルト表示されるルーティング先
      initialLocation: '/agoravideochanneljoin',

      // ルーティング先
      // improve：ルーティング先をグループ化してコンポーネント化し、着脱容易にしたい。
      routes: [
        //  デフォルト表示
        GoRoute(
          path: '/agoravideochanneljoin',
          builder: (context, state) {
            return const AgoraVideoChannelJoinPage();
          },
          routes: [
            GoRoute(
              path: 'agoravideo',
              builder: (context, state) {
                return const AgoraVideoPage();
              },
            )
          ],
        ),

        GoRoute(
          path: '/changepassword',
          builder: (context, state) => const ChangePasswordPage(),
        ),

        GoRoute(
          path: '/user',
          builder: (context, state) => const UserPage(),
        ),
      ],

      // リダイレクト設定
      // improve：if文での分岐を抽象化したい。
      redirect: (state) {
        // rtc channel join済・未joinの状態監視
        final RtcChannelState rtcChannelState = ref.watch(
            RtcChannelStateNotifierProviderList
                .rtcChannelStateNotifierProvider);

        // rtc channel join済・未joinの状態を監視し、
        // 状態が変化した場合、リダイレクト操作が実施される。
        if (rtcChannelState.joined) {
          if (state.subloc == '/agoravideochanneljoin/agoravideo') {
            return null;
          } else {
            return '/agoravideochanneljoin/agoravideo';
          }
        }
      },
    );
  },
);
