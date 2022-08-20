// StateNotifier
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'user_fetch_all_usecase.dart';
import 'user_detail_page.dart';

// Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'user_detail_page_state.dart';
import 'user_repository_firestore.dart';

import 'user_delete_usecase.dart';
import 'user.dart';
import 'user_fetch_by_id_usecase.dart';
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
    required Widget pageTitleWidget,

    // User List Widget
    required Widget userListWidget,
    required UserDeleteUseCase userDeleteUseCase,
    required StreamProvider<Users> usersStreamProvider,
    required UserFetchByIdUseCase userFindByIdUseCase,

    // User Add Button
    required String userAddButtonName,
    required Widget userAddButton,
  }) = _UserPageState;

  // Factory Constructor
  factory UserPageState.create() => UserPageState._(
        // Page Title
        pageTitle: "ユーザぺージ",
        pageTitleWidget: const Placeholder(),

        // User List Widget
        userListWidget: const Placeholder(),
        userDeleteUseCase: UserDeleteUseCase(
            userRepository: UserRepositoryFireBase(
                firebaseFirestoreInstance: FirebaseFirestore.instance)),
        usersStreamProvider: StreamProvider<Users>((ref) {
          return UserFetchAllUseCase(
                  userRepository: UserRepositoryFireBase(
                      firebaseFirestoreInstance: FirebaseFirestore.instance))
              .execute();
        }),
        userFindByIdUseCase: UserFetchByIdUseCase(
            userRepository: UserRepositoryFireBase(
                firebaseFirestoreInstance: FirebaseFirestore.instance)),

        // User Add Button
        userAddButtonName: "ユーザ追加",
        userAddButton: const Placeholder(),
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class UserPageStateController extends StateNotifier<UserPageState> {
  UserPageStateController() : super(UserPageState.create()) {
    buildPageTitleWidget();
    buildUserListWidget();
    buildUserAddButton();
  }

  // Page Title
  void buildPageTitleWidget() {
    final Widget widget = Text(state.pageTitle);

    state = state.copyWith(pageTitleWidget: widget);
  }

  // User List Widget
  void buildUserListWidget() {
    final widget = Consumer(
      builder: (context, ref, child) {
        final usersStream = ref.watch(state.usersStreamProvider);
        return usersStream.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stacktrace) => const Text("error"),
          data: (data) {
            return Flexible(
              child: ListView.builder(
                  itemCount: data.users.length,
                  itemBuilder: (context, index) {
                    final user = data.users[index];
                    final email = user.email;
                    final userId = user.userId.value.toString();

                    return ListTile(
                      title: Text(email),
                      subtitle: Text(userId),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          state.userDeleteUseCase.execute(userId);
                        },
                      ),
                      onTap: () async {
                        final User user =
                            await state.userFindByIdUseCase.execute(userId);
                        final notifier = ref.read(
                            userDetailPageStateControllerProvider.notifier);
                        notifier.setUserEmailAndPassword(ref, user);
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const UserDetailPage();
                          },
                        );
                        notifier.clearUserEmailAndPassword(ref);
                      },
                    );
                  }),
            );
          },
        );
      },
    );
    state = state.copyWith(userListWidget: widget);
  }

  // User Add Button
  void buildUserAddButton() {
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        return IconButton(
          onPressed: () async {
            final notifier =
                ref.read(userDetailPageStateControllerProvider.notifier);

            notifier.clearUserEmailAndPassword(ref);
            await showModalBottomSheet(
              context: context,
              builder: (context) {
                return const UserDetailPage();
              },
            );
            notifier.clearUserEmailAndPassword(ref);
          },
          icon: const Icon(Icons.person_add),
          tooltip: state.userAddButtonName,
        );
      },
    );
    state = state.copyWith(userAddButton: widget);
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
