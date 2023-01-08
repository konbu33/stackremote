import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: pointerのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../channel/channel.dart';
import '../../../common/common.dart';
import '../../../user/user.dart';

import '../widget/video_main_widget.dart';
import '../widget/video_sub_widget.dart';
import 'rtc_video_page_state.dart';

class RtcVideoPage extends ConsumerWidget {
  const RtcVideoPage({super.key});

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
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          RtcVideoPageWidgets.videoMainWidget(),
          RtcVideoPageWidgets.videoSubWidget(),
          RtcVideoPageWidgets.updateUsersStateWidget(),
          RtcVideoPageWidgets.attentionMessageWidget(),
          RtcVideoPageWidgets.channelLeaveProgressWidget(),
        ],
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
  static Widget updateUsersStateWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      // users情報取得に失敗した場合、通知する。
      final usersState = ref.watch(usersStateNotifierProvider);

      if (usersState.isGetDataError) {
        const snackBar = SnackBar(content: Text("ユーザ情報の取得に失敗しました。"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // localのuserState更新時に、リモートDB上へも反映するためのプロバイダ
      ref.watch(updateUserCommentProvider);
      ref.watch(updateUserIsOnLongPressingProvider);
      ref.watch(updateUserPointerPositionProvider);
      ref.watch(updateUserDisplaySizeVideoMainProvider);

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
