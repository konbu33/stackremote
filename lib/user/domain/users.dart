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

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UsersStateNotifier extends Notifier<Users> {
  @override
  Users build() {
    final userFetchAllUsecase = ref.watch(userFetchAllUsecaseProvider);
    final usersStream = userFetchAllUsecase();

    // usersStreamのConsuming開始。

    // stateの初期化は、returnで行われると思われる。
    // 初期化以降、このlistenで購読をし続けてけており、データが流れてきたら、stateを再更新する流れになると思われる。

    // この時点で、エラー処理したい場合は、Streamのまま購読せずに、
    // StreamProviderを介して、AsyncValueとして購読した方が、コードわかりやすくなりそう。
    usersStream.listen((event) {
      final users = Users.create(users: event.users);
      state = users;
    });

    // stateの初期化は、このreturnで行われると思われる。
    final users = Users.create(users: []);
    return users;
  }
}

// // --------------------------------------------------
// //
// // StateNotifier
// //
// // --------------------------------------------------
// class UsersStateNotifier extends Notifier<Users> {
//   @override
//   Users build() {
//     final usersStream = ref.watch(usersStreamProvider);

//     // usersStreamのConsuming開始。
//     // stateの初期化は、returnで行われると思われる。
//     // 初期化以降、このlistenで購読をし続けてけており、データが流れてきたら、stateを再更新する流れになると思われる。
//     final usersList = usersStream.when(data: (data) {
//       return data.users;
//     }, error: (error, stackTrace) {
//       return [];
//     }, loading: () {
//       return [];
//     });

//     List<User> newUsersList = [];

//     if (usersList.isNotEmpty) {
//       newUsersList = usersList as List<User>;
//     }

//     // stateの初期化は、このreturnで行われると思われる。
//     final users = Users.create(users: newUsersList);
//     return users;
//   }
// }

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final usersStateNotifierProvider =
    NotifierProvider<UsersStateNotifier, Users>(() => UsersStateNotifier());

// // --------------------------------------------------
// //
// // usersStreamProvider
// //
// // --------------------------------------------------

// final usersStreamProvider = StreamProvider<Users>((ref) {
//   final userFetchAllUsecase = ref.watch(userFetchAllUsecaseProvider);
//   final usersStream = userFetchAllUsecase();
//   return usersStream;
// });
