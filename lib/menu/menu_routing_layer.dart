import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication/authentication.dart';
import '../common/common.dart';
import '../rtc_video/rtc_video.dart';
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
// MenuRoutingPath
//
// --------------------------------------------------
enum MenuRoutingPath {
  rtcVideoChannelJoin(path: '/rtc_video_channel_join'),

  changePassword(path: 'change_password'),
  rtcVideoChannelJoinChangePassword(
      path: '/rtc_video_channel_join/change_password'),

  user(path: 'user'),
  rtcVideoChannelJoinUser(path: '/rtc_video_channel_join/user'),

  rtcVideo(path: '/rtc_video');

  const MenuRoutingPath({
    required this.path,
  });

  final String path;
}

// --------------------------------------------------
//
// go_router
//
// --------------------------------------------------
final menuRouterProvider = Provider((ref) {
  // improve：肥大化しそうなため、分割を検討

  return GoRouter(
    // デフォルト表示されるルーティング先
    initialLocation: MenuRoutingPath.rtcVideoChannelJoin.path,

    // ルーティング先
    // improve：ルーティング先をグループ化してコンポーネント化し、着脱容易にしたい。
    routes: [
      //  デフォルト表示
      GoRoute(
        path: MenuRoutingPath.rtcVideoChannelJoin.path,
        builder: (context, state) {
          return const RtcVideoChannelJoinPage();
        },
        routes: [
          GoRoute(
            path: MenuRoutingPath.changePassword.path,
            builder: (context, state) => const ChangePasswordPage(),
          ),
          GoRoute(
            path: MenuRoutingPath.user.path,
            builder: (context, state) => const UserPage(),
          ),
        ],
      ),

      GoRoute(
        path: MenuRoutingPath.rtcVideo.path,
        builder: (context, state) {
          return const RtcVideoPage();
        },
      ),
    ],

    // リダイレクト設定
    redirect: (context, state) {
      // rtc channel join済の場合
      final isJoinedChannel = ref.watch(RtcVideoState.isJoinedChannelProvider);
      if (isJoinedChannel) return MenuRoutingPath.rtcVideo.path;

      // rtc channel join未の場合、
      // context.goなどで明示的に指定さている場合、指定先へ遷移。 未指定の場合、initialLocationへ遷移
      return null;
    },
  );
});
