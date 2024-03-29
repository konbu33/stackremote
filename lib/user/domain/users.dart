import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';

import '../usecace/user_fetch_all_usecase.dart';
import 'user.dart';

part 'users.freezed.dart';

// --------------------------------------------------
//
// Users
//
// --------------------------------------------------
@freezed
class Users with _$Users {
  const factory Users._({
    required List<User> users,
    @Default(false) bool isGetDataError,
  }) = _Users;

  factory Users.create({
    required List<User> users,
    bool? isGetDataError,
  }) =>
      Users._(
        users: users,
        isGetDataError: isGetDataError ?? false,
      );

  factory Users.reconstruct({
    List<User>? users,
    bool? isGetDataError,
  }) =>
      Users._(
        users: users ?? [],
        isGetDataError: isGetDataError ?? false,
      );
}

// --------------------------------------------------
//
// UsersStateNotifier
//
// --------------------------------------------------
class UsersStateNotifier extends Notifier<Users> {
  @override
  Users build() {
    final usersStream = ref.watch(usersStreamProvider);

    // usersStreamのConsuming開始。
    // このwhenで購読し続けてけており、データが流れてきたら、stateを初期化する流れになると思われる。
    final users = usersStream.when(data: (data) {
      return Users.create(isGetDataError: false, users: data.users);
    }, error: (error, stackTrace) {
      return Users.create(isGetDataError: true, users: []);
    }, loading: () {
      return Users.create(isGetDataError: false, users: []);
    });

    logger.d("usersState: $users");
    return users;
  }
}

// --------------------------------------------------
//
// usersStateNotifierProvider
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
