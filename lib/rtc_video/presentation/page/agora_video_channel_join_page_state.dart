// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: authenticationのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../authentication/authentication.dart';

part 'agora_video_channel_join_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class AgoraVideoChannelJoinPageState with _$AgoraVideoChannelJoinPageState {
  const factory AgoraVideoChannelJoinPageState._({
    // PageTitle
    required String pageTitle,
    required String message,

    // SignOutIcon Button
    required String signOutIconButtonName,
    // required AuthenticationServiceSignOutUsecase
    //     authenticationServiceSignOutUsecase,
    required AppbarActionIconStateProvider signOutIconStateProvider,
  }) = _AgoraVideoChannelJoinPageState;

  factory AgoraVideoChannelJoinPageState.create() =>
      AgoraVideoChannelJoinPageState._(
        // PageTitle
        pageTitle: "チャンネル参加",

        message: "",

        // Sign Out Button
        signOutIconButtonName: "サインアウト",
        // authenticationServiceSignOutUsecase:
        //     AuthenticationServiceSignOutUsecase(
        //   authenticationService: AuthenticationServiceFirebase(
        //     instance: firebase_auth.FirebaseAuth.instance,
        //   ),
        // ),

        signOutIconStateProvider: appbarActionIconStateProviderCreator(
          onSubmitWidgetName: "",
          icon: const Icon(null),
          onSubmit: null,
        ),
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class AgoraVideoChannelJoinPageStateNotifier
    extends StateNotifier<AgoraVideoChannelJoinPageState> {
  AgoraVideoChannelJoinPageStateNotifier({
    required this.ref,
  }) : super(AgoraVideoChannelJoinPageState.create()) {
    initial();
  }

  // ref
  final Ref ref;

  // initial
  void initial() {
    state = AgoraVideoChannelJoinPageState.create();
    // setOnSubmit();
    setSignOutIconOnSubumit();
  }

  void setMessage(String message) {
    state = state.copyWith(message: message);
  }

  // setSignOutIconOnSubumit
  void setSignOutIconOnSubumit() {
    Function buildOnSubmit() {
      return ({
        required BuildContext context,
      }) =>
          () {
            final authenticationServiceSignOutUsecase =
                ref.read(authenticationServiceSignOutUsecaseProvider);

            authenticationServiceSignOutUsecase.execute();
            // state.authenticationServiceSignOutUsecase.execute();
          };
    }

    state = state.copyWith(
      signOutIconStateProvider: appbarActionIconStateProviderCreator(
        onSubmitWidgetName: state.signOutIconButtonName,
        icon: const Icon(Icons.logout),
        onSubmit: buildOnSubmit(),
      ),
    );
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final agoraVideoChannelJoinPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<AgoraVideoChannelJoinPageStateNotifier,
        AgoraVideoChannelJoinPageState>(
  (ref) => AgoraVideoChannelJoinPageStateNotifier(ref: ref),
);
