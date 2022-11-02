import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/user.dart';

// improve: authentication関連への依存関係を無くしたい。
import '../../../authentication/authentication.dart';

import '../../../common/common.dart';
import '../widget/nickname_field_widget.dart';
import 'user_page_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userPageStateControllerProvider);

    final userState = ref.watch(userStateNotifierProvider);

    final nickNameFieldState =
        ref.watch(state.nickNameFieldStateNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: UserDetailPageWidgets.pageTitleWidget(state),
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [nickNameFieldState.focusNode],
        children: [
          Form(
            key: state.userPageformValueKey,
            child: Column(
              children: [
                Text(
                    "現在のニックネーム：${userState.nickName.isEmpty ? "未登録" : userState.nickName}"),
                const SizedBox(height: 40),
                UserDetailPageWidgets.userNameField(state),
                const SizedBox(height: 40),
                UserDetailPageWidgets.userUpdateButton(state),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserDetailPageWidgets {
  // Page Title
  static Widget pageTitleWidget(UserPageState state) {
    final Widget widget = Text(state.pageTitle);
    return widget;
  }

  // User Name Field
  static Widget userNameField(UserPageState state) {
    final Widget widget = NickNameFieldWidget(
        nickNameFieldStateNotifierProvider:
            state.nickNameFieldStateNotifierProvider);

    return widget;
  }

  // User Update Button
  static Widget userUpdateButton(UserPageState state) {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      final loginIdIsValidate = ref.watch(state
          .nickNameFieldStateNotifierProvider
          .select((value) => value.nickNameIsValidate.isValid));

      if (loginIdIsValidate != state.isOnSubmitable) {
        // improve: addPostFrameCallbackの代替として、StatefulWidgetのmountedなど検討。
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final notifier = ref.read(userPageStateControllerProvider.notifier);
          notifier.updateIsOnSubmitable(loginIdIsValidate);
          notifier.setUserUpdateOnSubmit();
        });
      }

      return LoginSubmitWidget(
        loginSubmitStateProvider: state.userUpdateSubmitStateProvider,
      );
    }));

    return widget;
  }
}




// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:stackremote/user/domain/users.dart';

// // improve: authentication関連への依存関係を無くしたい。
// import '../../../authentication/authentication.dart';

// // import '../widget/user_list_widget.dart';

// import '../widget/user_list_widget.dart';
// import 'user_detail_page_state.dart';
// import 'user_page_state.dart';

// class UserPage extends HookConsumerWidget {
//   const UserPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(userPageStateControllerProvider);
//     // final notifier = ref.read(userDetailPageStateControllerProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         // title: UserPageWidgets.pageTitleWidget(state),
//         actions: [
//           // UserPageWidgets.userAddButton(state, notifier),
//           // UserPageWidgets.signOutIconButton(state),
//         ],
//       ),
//       body: Column(
//         children: [
//           // UserPageWidgets.userListWidget(state),
//           UserPageWidgets.userListWidget(),
//           UserPageWidgets.goToAgoraVideoPage(),
//         ],
//       ),
//     );
//   }
// }

// class UserPageWidgets {
//   // pageTitleWidget
//   // static Widget pageTitleWidget(
//   //   UserPageState state,
//   // ) {
//   //   final Widget widget = Text(state.pageTitle);

//   //   return widget;
//   // }

//   // //  userAddButton
//   // static Widget userAddButton(
//   //   UserPageState state,
//   //   UserDetailPageStateController notifier,
//   // ) {
//   //   final Widget widget = AppbarAcitonIconWidget(
//   //     appbarActionIconStateProvider: state.userAddIconStateProvider,
//   //   );

//   //   return widget;
//   // }

//   // // signOutIconButton
//   // static Widget signOutIconButton(UserPageState state) {
//   //   final Widget widget = AppbarAcitonIconWidget(
//   //     appbarActionIconStateProvider: state.signOutIconStateProvider,
//   //   );

//   //   return widget;
//   // }

//   // // userListWidget
//   // static Widget userListWidget(
//   //   UserPageState state,
//   // ) {
//   //   final widget = UserListWidget(
//   //     state: state,
//   //   );

//   //   return widget;
//   // }

//   // userListWidget
//   static Widget userListWidget() {
//     final widget = UserListWidget();

//     return widget;
//   }

//   // goToAgoraVideoPage
//   static Widget goToAgoraVideoPage() {
//     final widget = Builder(
//       builder: (context) => ElevatedButton(
//         onPressed: () {
//           context.push("/agoravideo");
//         },
//         child: const Text("Go To Agora Video"),
//       ),
//     );

//     return widget;
//   }
// }
