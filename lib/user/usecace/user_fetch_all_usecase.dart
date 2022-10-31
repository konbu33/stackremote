// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';

// import '../../channel/domain/channel_repository.dart';
// import '../../common/common.dart';
import '../../rtc_video/rtc_video.dart';
// import '../domain/user.dart';
import '../domain/users.dart';

final userFetchAllUsecaseProvider = Provider((ref) {
  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Stream<Users> execute() {
    return userRepository.fetchAll(
      channelName: rtcChannelState.channelName,
    );

    // // Stream<QuerySnapshot> execute() {
    // final Stream<QuerySnapshot<JsonMap>> snapshotStream = FirebaseFirestore
    //     .instance
    //     .collection('channels')
    //     .doc(rtcChannelState.channelName)
    //     .collection('users')
    //     .snapshots();

    // logger.d("execute : ");

    // Stream<Users> transferStream(
    //     Stream<QuerySnapshot<JsonMap>> snapshotStream) async* {
    //   // Out snapshot from Stream
    //   await for (final snapshot in snapshotStream) {
    //     // from Firestore Snapshot to User Type Object Collection.
    //     final docDatas = snapshot.docs.map(((doc) {
    //       final docData = doc.data();
    //       // final User user = User.create(
    //       //   nickName: docData["nickName"],
    //       //   isHost: docData["isHost"],
    //       //   joinedAt: const TimestampConverter().fromJson(docData["joinedAt"]),
    //       //   leavedAt: docData["leavedAt"],
    //       //   isOnLongPressing: docData["isOnLongPressing"],
    //       //   pointerPosition:
    //       //       const OffsetConverter().fromJson(docData["pointerPosition"]),
    //       // );
    //       // return user;
    //       // logger.d("$docData");

    //       // final manualData = {
    //       //   "isHost": true,
    //       //   "nickName": "ホストユーザ",
    //       //   "joinedAt": Timestamp(1666833125, 741000000),
    //       //   "leavedAt": null,
    //       //   "pointerPosition": {"dx": 0.0, "dy": 0.0},
    //       //   "isOnLongPressing": false,
    //       // };
    //       // return User.fromJson(manualData);
    //       return User.fromJson(docData);
    //     })).toList();

    //     final Users users = Users.reconstruct(users: docDatas);
    //     yield users;
    //   }
    // }

    // logger.d("transferStream :  ");
    // return transferStream(snapshotStream);
    // // return snapshotStream;
  }

  return execute;
});

// import '../domain/user_repository.dart';
// import '../domain/users.dart';

// class UserFetchAllUseCase {
//   // Constructor
//   const UserFetchAllUseCase({
//     required this.userRepository,
//   });

//   // Repository
//   final UserRepository userRepository;

//   // UseCase Execute
//   Stream<Users> execute() {
//     // Construct Dimain Model Object

//     // Repository Execute
//     final data = userRepository.fetchAll();

//     // return users;
//     return data;
//   }
// }
