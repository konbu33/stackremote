import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/presentation/authentication_service_firebase.dart';
import 'package:stackremote/authentication/usecase/authentication_service_auth_state_changes_usecase.dart';

// import 'custom_mouse_cursor/custom_mouse_cursor_overlayer_state.dart';
import 'userid.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class User with _$User {
  const factory User._({
    @UserIdConverter() required UserId userId,
    required String email,
    @Default(false) bool isSignIn,
    @OffsetConverter() required Offset cursorPosition,
    @Default(false) bool isOnLongPressing,
    // @CursorPositionConverter() required CursorPosition cursorPosition,
    // @CustomMouseCursorOerlayerStateConverter()
    //     required CustomMouseCursorOerlayerState customMouseCursorOerlayerState,
  }) = _User;

  factory User.create({
    required UserId userId,
    required String email,
    bool? isSignIn,
    Offset? cursorPosition,
    bool? isOnLongPressing,
  }) =>
      User._(
        userId: userId,
        email: email,
        isSignIn: isSignIn ?? false,
        cursorPosition: cursorPosition ?? const Offset(0, 0),
        isOnLongPressing: isOnLongPressing ?? false,
        // cursorPosition: CursorPosition.initial(),
        // customMouseCursorOerlayerState:
        //     CustomMouseCursorOerlayerState.initial(),
      );

  factory User.reconstruct({
    required UserId userId,
    required String email,
    bool? isSignIn,
    Offset? cursorPosition,
    bool? isOnLongPressing,
    // required CustomMouseCursorOerlayerState customMouseCursorOerlayerState,
  }) =>
      User._(
        userId: userId,
        email: email,
        isSignIn: isSignIn ?? false,
        cursorPosition: cursorPosition ?? const Offset(0, 0),
        isOnLongPressing: isOnLongPressing ?? false,
        // cursorPosition: CursorPosition.initial(),
        // customMouseCursorOerlayerState:
        //     CustomMouseCursorOerlayerState.initial(),
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// --------------------------------------------------
//
//  JsonConverter
//
// --------------------------------------------------
class OffsetConverter extends JsonConverter<Offset, String> {
  const OffsetConverter();

  @override
  String toJson(Offset object) {
    final double dx = object.dx;
    final double dy = object.dy;
    final Map<String, double> jsonMap = {
      "dx": dx,
      "dy": dy,
    };
    return jsonEncode(jsonMap);
  }

  @override
  Offset fromJson(String json) {
    final Map<String, dynamic> jsonMap = jsonDecode(json);
    final double dx = jsonMap["dx"];
    final double dy = jsonMap["dy"];

    return Offset(dx, dy);
  }
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class UserStateNotifier extends StateNotifier<User> {
  UserStateNotifier()
      : super(User.create(
          userId: UserId.create(value: "ini"),
          email: "ini",
        )) {
    // rebuild();
    // initial();
  }

  // void initial() {
  //   final authStatusChanges = AuthenticationServiceAuthStatusChangesUsecase(
  //           authenticationService:
  //               AuthenticationServiceFirebase(instance: FirebaseAuth.instance))
  //       .execute;

  //   try {
  //     authStatusChanges().listen((user) {
  //       userInformationRegiser(user);
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     print(" user : ------------------------- ${e}");
  //   }
  // }

  void userInformationRegiser(User user) {
    print(
        "userInformationRegiser -------------------------- : ${user.toString()}");
    state = state.copyWith(
      userId: user.userId,
      email: user.email,
      isSignIn: user.isSignIn,
    );
  }

  // // init
  // void initial() {
  //   state = SignInPageState.create();
  // }

  // // Rebuild
  // void rebuild() {
  //   buidUserInformationWidget();
  //   buildSignUpWidget();
  //   buildLoginIdField();
  //   buildPasswordField();
  //   buildLoginSubmitWidget();
  // }

  // // SignUp Widget
  // void buildSignUpWidget() {
  //   const Widget widget = SignUpWidget();

  //   state = state.copyWith(singUpWidget: widget);
  // }

  // // Login Id Field Widget
  // void buildLoginIdField() {
  //   Widget widget = LoginIdFieldWidget(
  //     loginIdFieldstateProvider: state.loginIdFieldStateProvider,
  //   );

  //   state = state.copyWith(loginIdField: widget);
  // }

  // // Password Field Widget
  // void buildPasswordField() {
  //   final Widget widget = PasswordFieldWidget(
  //     passwordFieldStateProvider: state.passwordFieldStateProvider,
  //   );

  //   state = state.copyWith(passwordField: widget);
  // }

  // // Login Submit Widget
  // void buildLoginSubmitWidget() {
  //   final Widget widget = LoginSubmitWidget(
  //     loginIdFieldStateProvider: state.loginIdFieldStateProvider,
  //     passwordFieldStateProvider: state.passwordFieldStateProvider,
  //     loginSubmitStateProvider: state.loginSubmitStateProvider,
  //   );

  //   state = state.copyWith(loginSubmitWidget: widget);
  // }

  // void buidUserInformationWidget() {
  //   final Widget widget = Consumer(
  //     builder: (context, ref, child) {
  //       final authStatusChanges = ref.watch(state.authStatusChangesProvider);

  //       return authStatusChanges.when(
  //         data: (data) {
  //           return Text("User : ${data.email}");
  //         },
  //         error: (e, st) => Text("User : Error ${e}, ${st}"),
  //         loading: () => const CircularProgressIndicator(),
  //       );
  //     },
  //   );

  //   state = state.copyWith(userInformationWidget: widget);
  // }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final userStateNotifierProvider =
    StateNotifierProvider<UserStateNotifier, User>(
  (ref) => UserStateNotifier(),
);
