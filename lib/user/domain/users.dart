import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
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
class UsersStateNotifier extends StateNotifier<Users> {
  UsersStateNotifier({
    required List<User> users,
  }) : super(Users.create(users: users));
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final usersStateNotifierProvider =
    StateNotifierProvider<UsersStateNotifier, Users>((ref) {
  final usersStream = ref.watch(usersStreamProvider);

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

  return UsersStateNotifier(users: newUsersList);
});

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
