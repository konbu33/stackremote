// StateNotifier
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:stackremote/user/usecace/user_update_usecase.dart';
import '../../domain/user.dart';
import '../../../authentication/presentation/widget/login_submit_state.dart';
import '../widget/nickname_field_state.dart';

part 'user_page_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class UserPageState with _$UserPageState {
  // Private Constructor
  const factory UserPageState._({
    // Page Title
    required String pageTitle,

    // Form
    required GlobalKey<FormState> userPageformValueKey,

    // Current User
    required User? currentUser,

    // User Name Field
    required NickNameFieldStateNotifierProvider
        nickNameFieldStateNotifierProvider,

    // User Update Button
    // required UserUpdateUsecase userUpdateUsecase,
    required LoginSubmitStateProvider userUpdateSubmitStateProvider,

    // ignore: unused_element
    @Default(false) bool isOnSubmitable,
  }) = _UserPageState;

  // Factory Constructor
  factory UserPageState.create() => UserPageState._(
        // Page Title
        pageTitle: "ユーザ情報",

        // Form
        userPageformValueKey: GlobalKey<FormState>(),

        // Current User
        currentUser: null,

        // User Name Field
        nickNameFieldStateNotifierProvider:
            nickNameFieldStateNotifierProviderCreator(),

        userUpdateSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
          loginSubmitWidgetName: "ユーザ更新",
          onSubmit: null,
        ),
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UserPageStateController extends StateNotifier<UserPageState> {
  UserPageStateController({
    required this.ref,
  }) : super(UserPageState.create());

  // ref
  final Ref ref;

  void setUserNickName(User user) {
    // User Id Field Controller text set
    ref
        .read(state.nickNameFieldStateNotifierProvider.notifier)
        .setFieldText(user.nickName);
    // Password Field Controller text set
    // currentUser set
    state = state.copyWith(currentUser: user);
  }

  void updateIsOnSubmitable(bool isOnSubmitable) {
    state = state.copyWith(isOnSubmitable: isOnSubmitable);
  }

  void setUserUpdateOnSubmit() {
    Function? buildOnSubmit() {
      if (!state.isOnSubmitable) {
        return null;
      }

      return ({
        required BuildContext context,
      }) =>
          () {
            // improve : !で問題あある可能ある。"
            // final User user = state.currentUser!;

            // final userId = user.userId;
            final nickName = ref
                .read(state.nickNameFieldStateNotifierProvider)
                .nickNameFieldController
                .text;

            // ユーザ情報更新
            final notifier = ref.read(userStateNotifierProvider.notifier);
            notifier.setNickName(nickName);

            // final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);
            // userUpdateUsecase(nickName: nickName);

            // // 戻る
            // Navigator.pop(context);

            ref
                .read(state.nickNameFieldStateNotifierProvider.notifier)
                .initial();
          };
    }

    state = state.copyWith(
      userUpdateSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
        loginSubmitWidgetName: "ユーザ更新",
        onSubmit: buildOnSubmit(),
      ),
    );
  }

  void clearUserEmail() {
    ref.read(state.nickNameFieldStateNotifierProvider.notifier).initial();
    state = state.copyWith(currentUser: null);
  }
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final userPageStateControllerProvider =
    StateNotifierProvider<UserPageStateController, UserPageState>(
  (ref) => UserPageStateController(ref: ref),
);





// // StateNotifier
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// // Freezed
// import 'package:freezed_annotation/freezed_annotation.dart';

// // ignore: unused_import
// import 'package:flutter/foundation.dart';

// // improve: authentication関連への依存関係を無くしたい。
// import '../../../authentication/authentication.dart';

// import '../../domain/users.dart';
// import '../../infrastructure/user_repository_firestore.dart';
// import '../../usecace/user_delete_usecase.dart';
// import '../../usecace/user_fetch_all_usecase.dart';
// import '../../usecace/user_fetch_by_id_usecase.dart';

// // import 'user_detail_page.dart';
// // import 'user_detail_page_state.dart';

// part 'user_page_state.freezed.dart';

// // --------------------------------------------------
// //
// //   Freezed
// //
// // --------------------------------------------------
// @freezed
// class UserPageState with _$UserPageState {
//   // Private Constructor
//   const factory UserPageState._({
//     // Page Title
//     required String pageTitle,

//     // User Add Button
//     required String userAddButtonName,
//     required AppbarActionIconStateProvider userAddIconStateProvider,

//     // SignOutIcon Button
//     required String signOutIconButtonName,
//     required AuthenticationServiceSignOutUsecase
//         authenticationServiceSignOutUsecase,
//     required AppbarActionIconStateProvider signOutIconStateProvider,

//     // User List Widget
//     // required StreamProvider<Users> usersStreamProvider,
//     // required UserFetchByIdUseCase userFindByIdUseCase,
//     // required UserDeleteUseCase userDeleteUseCase,
//   }) = _UserPageState;

//   // Factory Constructor
//   factory UserPageState.create() => UserPageState._(
//         // Page Title
//         pageTitle: "ユーザぺージ",

//         // User Add Button
//         userAddButtonName: "ユーザ追加",
//         userAddIconStateProvider: appbarActionIconStateProviderCreator(
//           onSubmitWidgetName: "",
//           icon: const Icon(null),
//           onSubmit: null,
//         ),

//         // Sign Out Button
//         signOutIconButtonName: "サインアウト",
//         authenticationServiceSignOutUsecase:
//             AuthenticationServiceSignOutUsecase(
//           authenticationService: AuthenticationServiceFirebase(
//             instance: FirebaseAuth.instance,
//           ),
//         ),
//         signOutIconStateProvider: appbarActionIconStateProviderCreator(
//           onSubmitWidgetName: "",
//           icon: const Icon(null),
//           onSubmit: null,
//         ),

//         // // User List Widget
//         // usersStreamProvider: StreamProvider<Users>(
//         //   (ref) {
//         //     final userFetchAllUseCase = ref.watch(userFetchAllUsecaseProvider);
//         //     return userFetchAllUseCase();
//         //     // return UserFetchAllUseCase(
//         //     //   userRepository: UserRepositoryFireBase(
//         //     //       firebaseFirestoreInstance: FirebaseFirestore.instance),
//         //     // ).execute();
//         //   },
//         // ),

//         // userFindByIdUseCase: UserFetchByIdUseCase(
//         //   userRepository: UserRepositoryFireBase(
//         //       firebaseFirestoreInstance: FirebaseFirestore.instance),
//         // ),

//         // userDeleteUseCase: UserDeleteUseCase(
//         //   userRepository: UserRepositoryFireBase(
//         //       firebaseFirestoreInstance: FirebaseFirestore.instance),
//         // ),
//       );
// }

// // --------------------------------------------------
// //
// //  StateNotifier
// //
// // --------------------------------------------------
// class UserPageStateController extends StateNotifier<UserPageState> {
//   UserPageStateController({
//     required this.ref,
//   }) : super(UserPageState.create()) {
//     initial();
//   }

//   // ref
//   Ref ref;

//   // initial
//   void initial() {
//     // setUserAddIconOnSubumit();
//     // setSignOutIconOnSubumit();
//   }

//   // // setUserAddIconOnSubumit
//   // void setUserAddIconOnSubumit() {
//   //   Function buildOnSubmit() {
//   //     return ({
//   //       required BuildContext context,
//   //     }) =>
//   //         () async {
//   //           // final notifier =
//   //           //     ref.read(userDetailPageStateControllerProvider.notifier);

//   //           // // state.authenticationServiceSignOutUsecase.execute();
//   //           // // ModalBottomSheet処理内でのonSubmit処理を最終確定
//   //           // notifier.setUserAddOnSubmit();

//   //           // // 初期化処理
//   //           // notifier.clearUserEmailAndPassword();

//   //           // // ModalBottomSheetでの処理
//   //           // await showModalBottomSheet(
//   //           //   context: context,
//   //           //   builder: (context) {
//   //           //     return const UserDetailPage();
//   //           //   },
//   //           // );

//   //           // // 初期化処理
//   //           // notifier.clearUserEmailAndPassword();
//   //         };
//   //   }

//   //   state = state.copyWith(
//   //     userAddIconStateProvider: appbarActionIconStateProviderCreator(
//   //       onSubmitWidgetName: state.userAddButtonName,
//   //       icon: const Icon(Icons.person_add),
//   //       onSubmit: buildOnSubmit(),
//   //     ),
//   //   );
//   // }

//   // // setSignOutIconOnSubumit
//   // void setSignOutIconOnSubumit() {
//   //   Function buildOnSubmit() {
//   //     return ({
//   //       required BuildContext context,
//   //     }) =>
//   //         () {
//   //           state.authenticationServiceSignOutUsecase.execute();
//   //         };
//   //   }

//   //   state = state.copyWith(
//   //     signOutIconStateProvider: appbarActionIconStateProviderCreator(
//   //       onSubmitWidgetName: state.signOutIconButtonName,
//   //       icon: const Icon(Icons.logout),
//   //       onSubmit: buildOnSubmit(),
//   //     ),
//   //   );
//   // }
// }

// // --------------------------------------------------
// //
// //  StateNotifierProvider
// //
// // --------------------------------------------------
// final userPageStateControllerProvider =
//     StateNotifierProvider<UserPageStateController, UserPageState>(
//   (ref) => UserPageStateController(ref: ref),
// );
