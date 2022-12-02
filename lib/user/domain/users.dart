import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../usecace/user_fetch_all_usecase.dart';
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

  factory Users.create({
    required List<User> users,
  }) =>
      Users._(
        users: users,
      );

  factory Users.reconstruct({
    List<User>? users,
  }) =>
      Users._(
        users: users ?? [],
      );
}

// // --------------------------------------------------
// //
// // StateNotifier
// //
// // --------------------------------------------------
// class UsersStateNotifier extends Notifier<Users> {
//   @override
//   Users build() {
//     final userFetchAllUsecase = ref.watch(userFetchAllUsecaseProvider);
//     final usersStream = userFetchAllUsecase();

//     // usersStreamのConsuming開始。データが流れてきたら、stateを再構築する。
//     usersStream.listen((event) {
//       final users = Users.create(users: event.users);
//       state = users;
//       // return users;
//     });

//     final users = Users.create(users: []);
//     return users;
//   }

// }

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UsersStateNotifier extends Notifier<Users> {
  @override
  Users build() {
    final usersStream = ref.watch(usersStreamProvider);

    // usersStreamのConsuming開始。データが流れてきたら、stateを再構築する。
    final usersList = usersStream.when(data: (data) {
      return data.users;
    }, error: (error, stackTrace) {
      return [];
    }, loading: () {
      return [];
    });

    List<User> newUsersList = [];

    if (usersList.isNotEmpty) {
      newUsersList = usersList as List<User>;
    }

    final users = Users.create(users: newUsersList);
    return users;
  }
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final usersStateNotifierProvider =
    NotifierProvider<UsersStateNotifier, Users>(() => UsersStateNotifier());

// --------------------------------------------------
//
// usersStreamProvider
//
// --------------------------------------------------

final usersStreamProvider = StreamProvider<Users>((ref) {
  final userFetchAllUsecase = ref.watch(userFetchAllUsecaseProvider);
  final usersStream = userFetchAllUsecase();
  return usersStream;
});
