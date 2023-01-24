import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: pointerのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../channel/channel.dart';
import '../../../common/common.dart';
import '../../../user/user.dart';

import '../../domain/rtc_video_state.dart';
import '../../usecase/continuous_participation_time.dart';
import '../widget/rtc_video_control_widget.dart';
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
      drawer: RtcVideoPageWidgets.rtcVideoControlWidget(),
      appBar: AppBar(
        title: Tooltip(
          message: "チャンネル名",
          child: Text(channelName),
        ),
        actions: [
          RtcVideoPageWidgets.channelLeaveIconWidget(),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          RtcVideoPageWidgets.videoMainWidget(),
          RtcVideoPageWidgets.videoSubWidget(),
          RtcVideoPageWidgets.reflectStateWidget(),
          RtcVideoPageWidgets.updateUsersStateWidget(),
          RtcVideoPageWidgets.attentionMessageWidget(),
          RtcVideoPageWidgets.channelLeaveProgressWidget(),
          RtcVideoPageWidgets.continuousParticipationTimeLimitTimerWidget(),
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
  // rtcVideoControlWidget
  static Widget rtcVideoControlWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      return const RtcVideoControlWidget();
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

  // continuousParticipationTimeLimitTimerWidget
  static Widget continuousParticipationTimeLimitTimerWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      // Timer実行
      final continuousParticipationTimeLimitTimerCreator =
          ref.watch(continuousParticipationTimeLimitTimerCreatorProvider);

      final timer = continuousParticipationTimeLimitTimerCreator();

      // 上限をwatch
      final isOverContinuousParticipationTimeLimit = ref
          .watch(RtcVideoState.isOverContinuousParticipationTimeLimitProvider);

      // 上限を超えた場合、ChannelLeave
      if (isOverContinuousParticipationTimeLimit) {
        final channelLeaveSubmitIconStateNotifierProvider = ref.watch(
            RtcVideoPageState.channelLeaveSubmitIconStateNotifierProvider);

        final channelLeaveSubmitIconStateNotifier =
            ref.watch(channelLeaveSubmitIconStateNotifierProvider);

        unawaited(Future(() {
          // nullになる可能性が無いため、non-nullable指定(!指定)で実行する。
          channelLeaveSubmitIconStateNotifier.onSubmit(context: context)!();
        }));

        // Timer実行キャンセル
        timer.cancel();
      }

      return const SizedBox();
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

  // reflectStateWidget
  static Widget reflectStateWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      // localのuserState更新時に、リモートDB上へも反映するためのプロバイダ
      ref.watch(reflectUserCommentProvider);
      ref.watch(reflectUserIsOnLongPressingProvider);
      ref.watch(reflectUserPointerPositionProvider);
      ref.watch(reflectUserDisplaySizeVideoMainProvider);
      ref.watch(reflectUserColorProvider);
      ref.watch(reflectUserIsMuteVideoProvider);
      ref.watch(reflectUserUserColorProvider);

      ref.watch(reflectRtcVideoStateIsUserOutSideCameraProvider);

      return const SizedBox();
    }));

    return widget;
  }

  // updateUsersStateWidget
  static Widget updateUsersStateWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      // users情報取得に失敗した場合、通知する。
      final usersState = ref.watch(usersStateNotifierProvider);

      if (usersState.isGetDataError) {
        const snackBar = SnackBar(content: Text("ユーザ情報の取得に失敗しました。"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

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
