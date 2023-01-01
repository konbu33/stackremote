import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: pointerのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../channel/channel.dart';
import '../../../common/common.dart';
import '../../../pointer/pointer.dart';

import '../../../user/user.dart';

import '../widget/video_main_widget.dart';
import '../widget/video_sub_widget.dart';
import 'rtc_video_page_state.dart';

class RtcVideoPage extends HookConsumerWidget {
  const RtcVideoPage({Key? key}) : super(key: key);

// ---------------------------------------------------
//
//
//  build
//
//
// ---------------------------------------------------

  // Build UI
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelName = ref.watch(channelNameProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Tooltip(
          message: "チャンネル名",
          child: Text(channelName),
        ),
        actions: [
          RtcVideoPageWidgets.switchCameraIconWidget(),
          RtcVideoPageWidgets.channelLeaveIconWidget(),
        ],
      ),
      body: PointerOverlayWidget(
        child: Stack(
          children: [
            RtcVideoPageWidgets.videoMainWidget(),
            RtcVideoPageWidgets.videoSubWidget(),
            RtcVideoPageWidgets.getUserStateWidget(),
            RtcVideoPageWidgets.attentionMessageWidget(),
            RtcVideoPageWidgets.channelLeaveProgressWidget(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------
//
//
// PageWidgets
//
//
// ---------------------------------------------------

class RtcVideoPageWidgets {
  // switchCameraIconWidget
  static Widget switchCameraIconWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      return AppbarAcitonIconWidget(
        appbarActionIconStateNotifierProvider: ref.watch(
            RtcVideoPageState.switchCameraSubmitIconStateNotifierProvider),
      );
    }));

    return widget;
  }

  // channelLeaveIconWidget
  static Widget channelLeaveIconWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      return AppbarAcitonIconWidget(
        appbarActionIconStateNotifierProvider: ref.watch(
            RtcVideoPageState.channelLeaveSubmitIconStateNotifierProvider),
      );
    }));

    return widget;
  }

  // videoMainWidget
  static Widget videoMainWidget() {
    const Widget widget = VideoMainWidget();

    return widget;
  }

  // videoSubWidget
  static Widget videoSubWidget() {
    const Widget widget = VideoSubWidget();

    return widget;
  }

  // getUserStateWidget
  static Widget getUserStateWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      // final channelState = ref.watch(channelStateNotifierProvider);
      // logger.d("videochannel: $channelState");

      // final userState = ref.watch(userStateNotifierProvider);
      // logger.d("videouser: $userState");

      // users情報取得に失敗した場合、通知する。
      final usersState = ref.watch(usersStateNotifierProvider);
      // logger.d("videousers: $usersState");

      if (usersState.isGetDataError) {
        const snackBar = SnackBar(content: Text("ユーザ情報の取得に失敗しました。"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // localのpointerState更新時に、リモートDB上へも反映するhooks
      ref.watch(updateUserCommentProvider);
      ref.watch(updateUserIsOnLongPressingProvider);
      ref.watch(updateUserPointerPositionProvider);

      return const SizedBox();
    }));

    return widget;
  }

  // attentionMessageWidget
  static Widget attentionMessageWidget() {
    const textStyle = TextStyle(color: Colors.red);
    final Widget widget = Center(
      child: DescriptionMessageWidget(
        descriptionMessageStateProvider:
            RtcVideoPageState.attentionMessageStateProvider,
        textStyle: textStyle,
      ),
    );

    return widget;
  }

  // channelLeaveProgressWidget
  static Widget channelLeaveProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final channelLeaveProgressStateNotifierProvider = ref.watch(
          RtcVideoPageState
              .channelLeaveProgressStateNotifierProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider:
            channelLeaveProgressStateNotifierProvider,
      );
    });

    return widget;
  }
}
