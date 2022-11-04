import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../usecase/authentication_service_signout_usecase.dart';

import '../widget/appbar_action_icon_state.dart';

part 'wait_email_verified_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class WaitEmailVerifiedPageState with _$WaitEmailVerifiedPageState {
  const factory WaitEmailVerifiedPageState._({
    // PageTitle
    required String pageTitle,

    // SignOutIcon Button
    required String signOutIconButtonName,

    //
    required AppbarActionIconStateProvider signOutIconStateProvider,
  }) = _WaitEmailVerifiedPageState;

  factory WaitEmailVerifiedPageState.create() => WaitEmailVerifiedPageState._(
        // PageTitle
        pageTitle: "メールアドレス確認待ち",

        // SignOutIcon Button
        signOutIconButtonName: "サインアウト",

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
class WaitEmailVerifiedPageStateNotifier
    extends StateNotifier<WaitEmailVerifiedPageState> {
  WaitEmailVerifiedPageStateNotifier({
    required this.ref,
  }) : super(WaitEmailVerifiedPageState.create()) {
    initial();
  }

  // ref
  final Ref ref;

  // initial
  void initial() {
    state = WaitEmailVerifiedPageState.create();
    setSignOutIconOnSubumit();
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
final waitEmailVerifiedPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<WaitEmailVerifiedPageStateNotifier,
        WaitEmailVerifiedPageState>(
  (ref) => WaitEmailVerifiedPageStateNotifier(ref: ref),
);
