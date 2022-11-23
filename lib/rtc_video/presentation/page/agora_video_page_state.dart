import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widget/channel_leave_submit_icon_state.dart';

class AgoraVideoPageState {
  // --------------------------------------------------
  //
  //   viewSwitchProvider
  //
  // --------------------------------------------------
  static final viewSwitchProvider = StateProvider.autoDispose((ref) => false);

  // --------------------------------------------------
  //
  //  channelLeaveSubmitIconStateProvider
  //
  // --------------------------------------------------
  static final channelLeaveSubmitIconStateProvider =
      channelLeaveSubmitIconStateProviderCreator();
}
