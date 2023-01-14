import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';
import '../../channel/channel.dart';
import '../../common/common.dart';
import '../../pointer/pointer.dart';
import '../../rtc_video/rtc_video.dart';

import '../usecace/user_update_usecase.dart';
import 'nick_name.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// --------------------------------------------------
//
//   User
//
// --------------------------------------------------
@freezed
class User with _$User {
  const factory User._({
    @Default("") String comment,
    required String email,
    @Default(true) bool isHost,
    @Default(false) bool isOnLongPressing,
    @Default(null) @DateTimeConverter() DateTime? joinedAt,
    @Default(null) @DateTimeConverter() DateTime? leavedAt,
    @Default("") String nickName,
    @Default(Offset(0, 0)) @OffsetConverter() Offset pointerPosition,
    @Default(Offset(0, 0)) @OffsetConverter() Offset displayPointerPosition,
    required int rtcVideoUid,
    @Default(Size(0, 0)) @SizeConverter() Size displaySizeVideoMain,
    @Default(UserColor.red) @UserColorConverter() UserColor userColor,
    @Default(false) bool isMuteVideo,
  }) = _User;

  factory User.create({
    required String email,
    String? nickName,
    int? rtcVideoUid,
  }) =>
      User._(
        email: email,
        nickName: nickName ?? "",
        rtcVideoUid: rtcVideoUid ?? 0,
      );

  factory User.reconstruct({
    String? comment,
    String? email,
    bool? isHost,
    bool? isOnLongPressing,
    DateTime? joinedAt,
    DateTime? leavedAt,
    String? nickName,
    Offset? pointerPosition,
    Offset? displayPointerPosition,
    int? rtcVideoUid,
    Size? displaySizeVideoMain,
    UserColor? userColor,
    bool? isMuteVideo,
  }) =>
      User._(
        comment: comment ?? "",
        email: email ?? "",
        isHost: isHost ?? true,
        isOnLongPressing: isOnLongPressing ?? false,
        joinedAt: joinedAt,
        leavedAt: leavedAt,
        nickName: nickName ?? "",
        pointerPosition: pointerPosition ?? const Offset(0, 0),
        displayPointerPosition: displayPointerPosition ?? const Offset(0, 0),
        rtcVideoUid: rtcVideoUid ?? 0,
        displaySizeVideoMain: displaySizeVideoMain ?? const Size(0, 0),
        userColor: userColor ?? UserColor.red,
        isMuteVideo: isMuteVideo ?? false,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// --------------------------------------------------
//
//  UserStateNotifier
//
// --------------------------------------------------
class UserStateNotifier extends AutoDisposeNotifier<User> {
  @override
  User build() {
    final comment = ref
        .watch(pointerStateNotifierProvider.select((value) => value.comment));

    final email = ref.watch(
        firebaseAuthUserStateNotifierProvider.select((value) => value.email));

    final hostUserEmail = ref.watch(
        channelStateNotifierProvider.select((value) => value.hostUserEmail));

    final isHost = email == hostUserEmail;

    final isOnLongPressing = ref.watch(
        pointerStateNotifierProvider.select((value) => value.isOnLongPressing));

    final nickName = ref.watch(NickName.nickNameProvider);

    final pointerPosition = ref.watch(
        pointerStateNotifierProvider.select((value) => value.pointerPosition));

    final displayPointerPosition = ref.watch(pointerStateNotifierProvider
        .select((value) => value.displayPointerPosition));

    final rtcVideoUid = RtcVideoState.localUid;

    final displaySizeVideoMain =
        ref.watch(DisplaySizeVideoState.displaySizeVideoMainProvider);

    final userColor = ref
        .watch(pointerStateNotifierProvider.select((value) => value.userColor));

    final isMuteVideo = ref.watch(RtcVideoState.isMuteVideoLocalProvider);

    final user = User.reconstruct(
      comment: comment,
      email: email,
      isHost: isHost,
      isOnLongPressing: isOnLongPressing,
      nickName: nickName,
      pointerPosition: pointerPosition,
      displayPointerPosition: displayPointerPosition,
      rtcVideoUid: rtcVideoUid,
      displaySizeVideoMain: displaySizeVideoMain,
      userColor: userColor,
      isMuteVideo: isMuteVideo,
    );

    logger.d("userState: $user");
    return user;
  }
}

// --------------------------------------------------
//
//  userStateNotifierProvider
//
// --------------------------------------------------
final userStateNotifierProvider =
    AutoDisposeNotifierProvider<UserStateNotifier, User>(
        () => UserStateNotifier());

// --------------------------------------------------
//
//  UserColor
//
// --------------------------------------------------
enum UserColor {
  red(color: Colors.red),
  cyan(color: Colors.cyan),

  green(color: Colors.green),
  yellow(color: Colors.yellow),

  orange(color: Colors.orange),
  pink(color: Colors.pink),

  grey(color: Colors.grey),
  white(color: Colors.white),
  black(color: Colors.black),
  ;

  final Color color;
  const UserColor({required this.color});

  static UserColor fromJson(String json) {
    switch (json) {
      case 'UserColor.red':
        return UserColor.red;

      case 'UserColor.cyan':
        return UserColor.cyan;

      case 'UserColor.green':
        return UserColor.green;

      case 'UserColor.yellow':
        return UserColor.yellow;

      case 'UserColor.orange':
        return UserColor.orange;

      case 'UserColor.pink':
        return UserColor.pink;

      case 'UserColor.grey':
        return UserColor.grey;

      case 'UserColor.white':
        return UserColor.white;

      case 'UserColor.black':
        return UserColor.black;

      default:
        return UserColor.cyan;
    }
  }
}

// --------------------------------------------------
//
// updateUserCommentProvider
//
// --------------------------------------------------
final updateUserCommentProvider = Provider.autoDispose((ref) async {
  final comment =
      ref.watch(userStateNotifierProvider.select((value) => value.comment));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    comment: comment,
  );
});

// --------------------------------------------------
//
// updateUserIsOnLongPressingProvider
//
// --------------------------------------------------
final updateUserIsOnLongPressingProvider = Provider.autoDispose((ref) async {
  final isOnLongPressing = ref.watch(
      userStateNotifierProvider.select((value) => value.isOnLongPressing));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    isOnLongPressing: isOnLongPressing,
  );
});

// --------------------------------------------------
//
// updateUserPointerPositionProvider
//
// --------------------------------------------------
final updateUserPointerPositionProvider = Provider.autoDispose((ref) async {
  final pointerPosition = ref.watch(
      userStateNotifierProvider.select((value) => value.pointerPosition));

  final displayPointerPosition = ref.watch(userStateNotifierProvider
      .select((value) => value.displayPointerPosition));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    pointerPosition: pointerPosition,
    displayPointerPosition: displayPointerPosition,
  );
});

// --------------------------------------------------
//
// updateUserDisplaySizeVideoMainProvider
//
// --------------------------------------------------
final updateUserDisplaySizeVideoMainProvider =
    Provider.autoDispose((ref) async {
  final displaySizeVideoMain = ref.watch(
      userStateNotifierProvider.select((value) => value.displaySizeVideoMain));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    displaySizeVideoMain: displaySizeVideoMain,
  );
});

// --------------------------------------------------
//
// updateUserColorProvider
//
// --------------------------------------------------
final updateUserColorProvider = Provider.autoDispose((ref) async {
  final userColor =
      ref.watch(userStateNotifierProvider.select((value) => value.userColor));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    userColor: userColor,
  );
});

// --------------------------------------------------
//
// updateUserIsMuteVideoProvider
//
// --------------------------------------------------
final updateUserIsMuteVideoProvider = Provider.autoDispose((ref) async {
  final isMuteVideo =
      ref.watch(userStateNotifierProvider.select((value) => value.isMuteVideo));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    isMuteVideo: isMuteVideo,
  );
});
