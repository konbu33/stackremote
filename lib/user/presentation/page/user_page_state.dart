// StateNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../domain/users.dart';
import '../../infrastructure/user_repository_firestore.dart';
import '../../../authentication/usecase/authentication_service_signout_usecase.dart';
import '../../usecace/user_delete_usecase.dart';
import '../../usecace/user_fetch_all_usecase.dart';
import '../../usecace/user_fetch_by_id_usecase.dart';
import '../../../authentication/infrastructure/authentication_service_firebase.dart';
import '../../../authentication/presentation/widget/appbar_action_icon_state.dart';
import 'user_detail_page.dart';
import 'user_detail_page_state.dart';

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
    required AppbarActionIconStateProvider userAddIconStateProvider,

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
        userAddIconStateProvider: appbarActionIconStateProviderCreator(
          onSubmitWidgetName: "",
          icon: const Icon(null),
          onSubmit: () {},
        ),

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
  UserPageStateController({
    required this.ref,
  }) : super(UserPageState.create()) {
    initial();
  }

  // ref
  Ref ref;

  // initial
  void initial() {
    setUserAddIconOnSubumit();
    setSignOutIconOnSubumit();
  }

  // setUserAddIconOnSubumit
  void setUserAddIconOnSubumit() {
    Function buildOnSubmit() {
      return ({
        required BuildContext context,
      }) async {
        final notifier =
            ref.read(userDetailPageStateControllerProvider.notifier);

        // state.authenticationServiceSignOutUsecase.execute();
        // ModalBottomSheet処理内でのonSubmit処理を最終確定
        notifier.setUserAddOnSubmit();

        // 初期化処理
        notifier.clearUserEmailAndPassword();

        // ModalBottomSheetでの処理
        await showModalBottomSheet(
          context: context,
          builder: (context) {
            return const UserDetailPage();
          },
        );

        // 初期化処理
        notifier.clearUserEmailAndPassword();
      };
    }

    state = state.copyWith(
      userAddIconStateProvider: appbarActionIconStateProviderCreator(
        onSubmitWidgetName: state.userAddButtonName,
        icon: const Icon(Icons.person_add),
        onSubmit: buildOnSubmit(),
      ),
    );
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
  (ref) => UserPageStateController(ref: ref),
);
