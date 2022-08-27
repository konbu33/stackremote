// StateNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'user_fetch_all_usecase.dart';
import 'user_fetch_by_id_usecase.dart';
import 'user_delete_usecase.dart';
import 'user_repository_firestore.dart';
import 'users.dart';

part 'user_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class UserPageState with _$UserPageState {
  // Private Constructor
  const factory UserPageState._({
    // Page Title
    required String pageTitle,

    // User Add Button
    required String userAddButtonName,

    // SignOutIcon Button
    required String signOutIconButtonName,

    // User List Widget
    required StreamProvider<Users> usersStreamProvider,
    required UserFetchByIdUseCase userFindByIdUseCase,
    required UserDeleteUseCase userDeleteUseCase,
  }) = _UserPageState;

  // Factory Constructor
  factory UserPageState.create() => UserPageState._(
        // Page Title
        pageTitle: "ユーザぺージ",

        // User Add Button
        userAddButtonName: "ユーザ追加",

        // Sign Out Button
        signOutIconButtonName: "サインアウト",

        // User List Widget
        usersStreamProvider: StreamProvider<Users>(
          (ref) {
            return UserFetchAllUseCase(
              userRepository: UserRepositoryFireBase(
                  firebaseFirestoreInstance: FirebaseFirestore.instance),
            ).execute();
          },
        ),

        userFindByIdUseCase: UserFetchByIdUseCase(
          userRepository: UserRepositoryFireBase(
              firebaseFirestoreInstance: FirebaseFirestore.instance),
        ),

        userDeleteUseCase: UserDeleteUseCase(
          userRepository: UserRepositoryFireBase(
              firebaseFirestoreInstance: FirebaseFirestore.instance),
        ),
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class UserPageStateController extends StateNotifier<UserPageState> {
  UserPageStateController() : super(UserPageState.create());
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final userPageStateControllerProvider =
    StateNotifierProvider<UserPageStateController, UserPageState>(
  (ref) => UserPageStateController(),
);
