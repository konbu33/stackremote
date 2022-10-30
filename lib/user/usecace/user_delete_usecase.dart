import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';

// import '../../authentication/authentication.dart';
import '../../rtc_video/rtc_video.dart';

final userDeleteUsecaseProvider = Provider((ref) {
  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  // final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

  final UserRepository userRepository =
      ref.read(userRepositoryFirebaseProvider);

  Future<void> execute({
    required String email,
  }) async {
    userRepository.delete(
      channelName: rtcChannelState.channelName,
      email: email,
    );

    // await FirebaseFirestore.instance
    //     .collection('channels')
    //     .doc(rtcChannelState.channelName)
    //     .collection('users')
    //     .doc(email)
    //     .delete();
  }

  return execute;
});

// import '../domain/user_repository.dart';

// class UserDeleteUseCase {
//   // Constructor
//   const UserDeleteUseCase({
//     required this.userRepository,
//   });

//   // Repository
//   final UserRepository userRepository;

//   // UseCase Execute
//   Future<String> execute(
//     String userId,
//   ) async {
//     // Construct Dimain Model Object

//     // Repository Execute
//     final data = await userRepository.delete(userId);

//     return data;
//   }
// }
