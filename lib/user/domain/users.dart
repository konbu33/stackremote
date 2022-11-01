// StateNotifier
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/usecace/user_fetch_all_usecase.dart';
import 'user.dart';

part 'users.freezed.dart';

// --------------------------------------------------
//
// Freezed
// First Colection
//
// --------------------------------------------------
@freezed
class Users with _$Users {
  const factory Users._({
    required List<User> users,
  }) = _Users;

  factory Users.create() => const Users._(users: []);

  factory Users.reconstruct({
    required List<User> users,
  }) =>
      Users._(
        users: users,
      );
}

/*
// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UsersController extends StateNotifier<Users> {
  UsersController() : super(Users.create()) {
    _getInitData();
  }

  void resetData(List<User> users) {
    state = state.copyWith(users: users);
  }

  void _getInitData() {
    state = state.copyWith(
      users: [
        User.create(email: "init@test.com", password: "password"),
      ],
    );
  }

  void reconstruct(List<User> users) {
    state = state.copyWith(users: users);
  }
}
*/

// --------------------------------------------------
//
// StreamProvider
//
// --------------------------------------------------

final usersStreamProvider = StreamProvider<Users>((ref) {
// final usersStreamProvider = StreamProvider<QuerySnapshot>((ref) {
  final usersStream = ref.watch(userFetchAllUsecaseProvider);

  // final rtcChannelState = ref.watch(
  //     RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  // return FirebaseFirestore.instance
  //     .collection('channels')
  //     .doc(rtcChannelState.channelName)
  //     .collection('users')
  //     .snapshots();

  return usersStream();
});
