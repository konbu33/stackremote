import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: authentication関連への依存関係を無くしたい。
import '../../../authentication/authentication.dart';

import '../../../common/common.dart';
import '../../domain/user.dart';
import '../widget/nickname_field_widget.dart';
import 'user_page_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickNameFieldState =
        ref.watch(UserPageState.nickNameFieldStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: UserDetailPageWidgets.pageTitleWidget(),
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [nickNameFieldState.focusNode],
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: Column(
              children: [
                UserDetailPageWidgets.currentNickNameWidget(),
                const SizedBox(height: 40),
                UserDetailPageWidgets.userNameField(),
                const SizedBox(height: 40),
                UserDetailPageWidgets.userUpdateButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserDetailPageWidgets {
  // Page pageTitleWidget
  static Widget pageTitleWidget() {
    //
    const Widget widget = Text(UserPageState.pageTitle);
    return widget;
  }

  // currentNickNameWidget
  static Widget currentNickNameWidget() {
    //
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        final userState = ref.watch(userStateNotifierProvider);
        return Text("現在のニックネーム：${userState.nickName}");
      },
    );
    return widget;
  }

  // userNameField
  static Widget userNameField() {
    //
    final Widget widget = NickNameFieldWidget(
        nickNameFieldStateNotifierProvider:
            UserPageState.nickNameFieldStateNotifierProvider);

    return widget;
  }

  // userUpdateButton
  static Widget userUpdateButton() {
    //
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        return LoginSubmitWidget(
          loginSubmitStateProvider:
              ref.watch(UserPageState.userUpdateSubmitStateProvider),
        );
      },
    );

    return widget;
  }
}
