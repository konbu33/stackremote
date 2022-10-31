// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';

// import '../../channel/domain/channel_repository.dart';
// import '../../common/common.dart';
import '../../rtc_video/rtc_video.dart';
import '../domain/user.dart';

final userFetchByIdUsecaseProvider = Provider((ref) {
  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Stream<User> execute({
    required String email,
  }) {
    return userRepository.fetchById(
      channelName: rtcChannelState.channelName,
      email: email,
    );

    // final Stream<DocumentSnapshot<JsonMap>> snapshotStream = FirebaseFirestore
    //     .instance
    //     .collection('channels')
    //     .doc(rtcChannelState.channelName)
    //     .collection('users')
    //     .doc(email)
    //     .snapshots();

    // logger.d("execute : ");

    // Stream<User> transferStream(
    //     Stream<DocumentSnapshot<JsonMap>> snapshotStream) async* {
    //   await for (final snapshot in snapshotStream) {
    //     if (snapshot.data() != null) {
    //       final docData = snapshot.data() as JsonMap;
    //       yield User.fromJson(docData);
    //     }
    //   }
    // }

    // logger.d("transferStream :  ");
    // return transferStream(snapshotStream);
  }

  return execute;
});


// import '../domain/user.dart';
// import '../domain/user_repository.dart';

// class UserFetchByIdUseCase {
//   // Constructor
//   const UserFetchByIdUseCase({
//     required this.userRepository,
//   });

//   // Repository
//   final UserRepository userRepository;

//   // UseCase Execute
//   Future<User> execute(String userId) {
//     // Construct Dimain Model Object

//     // Repository Execute
//     final data = userRepository.fetchById(userId);

//     // return users;
//     return data;
//   }
// }
