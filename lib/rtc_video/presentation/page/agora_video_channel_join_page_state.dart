import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: authenticationのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../authentication/usecase/authentication_service_signout_usecase.dart';
import '../../../authentication/infrastructure/authentication_service_firebase.dart';
// import '../../usecase/authentication_service_signup_usecase.dart';
import '../../../authentication/presentation/widget/appbar_action_icon_state.dart';
// import '../widget/login_submit_state.dart';
// import '../widget/loginid_field_state.dart';

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

    // SignOutIcon Button
    required String signOutIconButtonName,
    required AuthenticationServiceSignOutUsecase
        authenticationServiceSignOutUsecase,
    required AppbarActionIconStateProvider signOutIconStateProvider,

    // // Login Id Field Widget
    // required LoginIdFieldStateProvider loginIdFieldStateProvider,

    // Login Submit Widget
    // @Default("新規登録") String loginSubmitWidgetName,
    // required AuthenticationServiceSignUpUsecase
    //     authenticationServiceSignUpUsecase,
    // required LoginSubmitStateProvider loginSubmitStateProvider,
  }) = _AgoraVideoChannelJoinPageState;

  factory AgoraVideoChannelJoinPageState.create() =>
      AgoraVideoChannelJoinPageState._(
        // PageTitle
        pageTitle: "チャンネル参加",

        // Sign Out Button
        signOutIconButtonName: "サインアウト",
        authenticationServiceSignOutUsecase:
            AuthenticationServiceSignOutUsecase(
          authenticationService: AuthenticationServiceFirebase(
            instance: firebase_auth.FirebaseAuth.instance,
          ),
        ),

        signOutIconStateProvider: appbarActionIconStateProviderCreator(
          onSubmitWidgetName: "",
          icon: const Icon(null),
          onSubmit: null,
        ),

        // // Login Id Field Widget
        // loginIdFieldStateProvider: loginIdFieldStateNotifierProviderCreator(),

        // // Login Submit
        // authenticationServiceSignUpUsecase: AuthenticationServiceSignUpUsecase(
        //     authenticationService: AuthenticationServiceFirebase(
        //         instance: firebase_auth.FirebaseAuth.instance)),

        // loginSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
        //   loginSubmitWidgetName: "",
        //   onSubmit: () {},
        // ),
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

  // void setOnSubmit() {
  //   Function buildOnSubmit() {
  //     return ({
  //       required BuildContext context,
  //     }) {
  //       final email = ref
  //           .read(state.loginIdFieldStateProvider)
  //           .loginIdFieldController
  //           .text;
  //       // state.authenticationServiceSignUpUsecase.execute(email);

  //       initial();
  //     };
  //   }

  //   state = state.copyWith(
  //       loginSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
  //           loginSubmitWidgetName: state.loginSubmitWidgetName,
  //           onSubmit: buildOnSubmit()));
  // }

  // setSignOutIconOnSubumit
  void setSignOutIconOnSubumit() {
    Function buildOnSubmit() {
      return ({
        required BuildContext context,
      }) =>
          () {
            state.authenticationServiceSignOutUsecase.execute();
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
