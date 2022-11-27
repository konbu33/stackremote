import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ulid/ulid.dart';

import '../usecase/create_rtc_id_token.dart';

class RtcChannelState {
// --------------------------------------------------
//
//   rtcIdTokenProvider
//
// --------------------------------------------------
  static final rtcIdTokenProvider = StateProvider((ref) async {
    final createRtcIdTokenUsecase =
        await ref.watch(createRtcIdTokenUsecaseProvider);

    final rtcIdToken = await createRtcIdTokenUsecase();
    return rtcIdToken;
  });

  static final account = Ulid().toString();

  static final isJoinedProvider = StateProvider((ref) => false);

  static final localUid = Random().nextInt(232 - 1);

  static const privilegeExpireTime = 4000;

  static final remoteUidProvider = StateProvider((ref) => 1);

  static const role = "publisher";

  static const rtcIdTokenType = "uid";
}
// // --------------------------------------------------
// //
// //   Freezed
// //
// // --------------------------------------------------
// @freezed
// class RtcChannelState with _$RtcChannelState {
//   @Assert('(localUid >= 0) && (localUid <= 232-1)', '有効値：0, 1～232-1')

//   //
//   const factory RtcChannelState._({
//     required String account,
//     required bool joined,
//     required int localUid,
//     //
//     required int privilegeExpireTime,
//     required int remoteUid,
//     required String role,
//     required String rtcIdTokenType,
//     //
//   }) = _RtcChannelState;

//   factory RtcChannelState.create() => RtcChannelState._(
//         account: Ulid().toString(),
//         joined: false,
//         localUid: Random().nextInt(232 - 1),
//         //
//         privilegeExpireTime: 4000,
//         remoteUid: 1,
//         role: "publisher",
//         rtcIdTokenType: "uid",
//       );
// }

// // --------------------------------------------------
// //
// //  StateNotifier
// //
// // --------------------------------------------------
// class RtcChannelStateNotifier extends StateNotifier<RtcChannelState> {
//   RtcChannelStateNotifier() : super(RtcChannelState.create());

//   void changeJoined(bool joined) {
//     state = state.copyWith(joined: joined);
//   }

//   void setRemoteUid(int remoteUid) {
//     state = state.copyWith(remoteUid: remoteUid);
//   }
// }

// // --------------------------------------------------
// //
// //  typedef Provider
// //
// // --------------------------------------------------
// typedef RtcChannelStateNotifierProvider
//     = StateNotifierProvider<RtcChannelStateNotifier, RtcChannelState>;

// // --------------------------------------------------
// //
// //  StateNotifierProviderCreator
// //
// // --------------------------------------------------
// RtcChannelStateNotifierProvider rtcChannelStateNotifierProviderCreator() {
//   return StateNotifierProvider<RtcChannelStateNotifier, RtcChannelState>((ref) {
//     return RtcChannelStateNotifier();
//   });
// }

// // --------------------------------------------------
// //
// //  rtcChannelStateNotifierProvider
// //
// // --------------------------------------------------
// final rtcChannelStateNotifierProvider =
//     rtcChannelStateNotifierProviderCreator();
