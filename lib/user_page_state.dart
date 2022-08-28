// StateNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:stackremote/authentication/presentation/authentication_service_firebase.dart';
import 'package:stackremote/authentication/presentation/widget/appbar_action_icon_state.dart';
import 'package:stackremote/authentication/usecase/authentication_service_signout_usecase.dart';

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
    required AuthenticationServiceSignOutUsecase
        authenticationServiceSignOutUsecase,
    required AppbarActionIconStateProvider signOutIconStateProvider,

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
        authenticationServiceSignOutUsecase:
            AuthenticationServiceSignOutUsecase(
          authenticationService: AuthenticationServiceFirebase(
            instance: FirebaseAuth.instance,
          ),
        ),
        signOutIconStateProvider: appbarActionIconStateProviderCreator(
          onSubmitWidgetName: "",
          icon: const Icon(null),
          onSubmit: () {},
        ),

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
  UserPageStateController() : super(UserPageState.create()) {
    initial();
  }

  // initial
  void initial() {
    setSignOutIconOnSubumit();
  }

  // setSignOutIconOnSubumit
  void setSignOutIconOnSubumit() {
    Function buildOnSubmit() {
      return ({
        required BuildContext context,
      }) {
        state.authenticationServiceSignOutUsecase.execute();
      };
    }

    state = state.copyWith(
      signOutIconStateProvider: appbarActionIconStateProviderCreator(
        onSubmitWidgetName: state.signOutIconButtonName,
        icon: const Icon(Icons.logout),
        onSubmit: buildOnSubmit(),
      ),
    );
  }
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
