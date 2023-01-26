import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';

import '../domain/rtc_video_state.dart';

final continuousParticipationTimeLimitTimerCreatorProvider =
    Provider.autoDispose((ref) {
  //

  Timer continuousParticipationTimeLimitTimerCreator() {
    const limit = RtcVideoState.continuousParticipationTimeLimitSec;

    final timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final timeRemaining = Duration(seconds: (limit - timer.tick));

        logger.d(
            "continuousParticipationTimeLimitTimer: timeRemaining: $timeRemaining Sec");

        // ChannelLeaveが発生した場合
        final isJoinedChannel =
            ref.watch(RtcVideoState.isJoinedChannelProvider);
        if (!isJoinedChannel) timer.cancel();

        // 残り時間が0秒以下になった場合
        if (timeRemaining.inSeconds <= 0) {
          ref
              .watch(RtcVideoState
                  .isOverContinuousParticipationTimeLimitProvider.notifier)
              .update((state) => true);

          timer.cancel();
        }

        // 残り時間を保持
        ref
            .watch(RtcVideoState
                .continuousParticipationTimeRemainingProvider.notifier)
            .update((state) => timeRemaining);
      },
    );

    return timer;
  }

  return continuousParticipationTimeLimitTimerCreator;
});
