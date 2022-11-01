// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:stackremote/authentication/authentication.dart';
// import 'package:stackremote/rtc_video/rtc_video.dart';

// import '../domain/user.dart';

// final userAddUsecaseProvider = Provider((ref) {
//   final rtcChannelState = ref.watch(
//       RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

//   final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

//   Future<void> execute({
//     required String nickName,
//     required bool isHost,
//     Timestamp? joinedAt,
//     Timestamp? leavedAt,
//     required bool isOnLongPressing,
//     required Offset pointerPosition,
//   }) async {
//     final User user = User.create(
//       nickName: nickName,
//       isHost: isHost,
//       joinedAt: joinedAt,
//       leavedAt: leavedAt,
//       isOnLongPressing: isOnLongPressing,
//       pointerPosition: pointerPosition,
//     );

//     await FirebaseFirestore.instance
//         .collection('channels')
//         .doc(rtcChannelState.channelName)
//         .collection('users')
//         .doc(firebaseAuthUser.email)
//         .set(user.toJson());
//   }

//   return execute;
// });

// // class UserAddUseCase {
// //   // Constructor
// //   const UserAddUseCase({
// //     required this.userRepository,
// //   });

// //   // Repository
// //   final UserRepository userRepository;

// //   // UseCase Execute
// //   Future<User> execute({
// //     required String nickName,
// //     required bool isHost,
// //     Timestamp? joinedAt,
// //     Timestamp? leavedAt,
// //     required bool isOnLongPressing,
// //     required Offset pointerPosition,
// //   }) async {
// //     // Construct Dimain Model Object
// //     final User user = User.create(
// //       nickName: nickName,
// //       isHost: isHost,
// //       joinedAt: joinedAt,
// //       leavedAt: leavedAt,
// //       isOnLongPressing: isOnLongPressing,
// //       pointerPosition: pointerPosition,
// //     );

// //     const docId = "xxx@test.com";

// //     // Repository Execute
// //     await userRepository.set(docId: docId, user: user);

// //     return user;
// //   }
// // }
