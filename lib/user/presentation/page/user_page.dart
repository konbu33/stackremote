import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../domain/user.dart';
import 'user_page_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickNameFieldStateNotifierProvider =
        ref.watch(UserPageState.nickNameFieldStateNotifierProviderOfProvider);

    final nickNameFieldState = ref.watch(nickNameFieldStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: UserDetailPageWidgets.pageTitleWidget(),
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [nickNameFieldState.focusNode],
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: Stack(
              children: [
                Column(
                  children: [
                    UserDetailPageWidgets.currentNickNameWidget(),
                    const SizedBox(height: 40),
                    UserDetailPageWidgets.attentionMessageWidget(),
                    const SizedBox(height: 40),
                    UserDetailPageWidgets.userNameField(),
                    const SizedBox(height: 40),
                    UserDetailPageWidgets.userUpdateButton(),
                  ],
                ),
                UserDetailPageWidgets.updateUserProgressWidget(),
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

// attentionMessageWidget
  static Widget attentionMessageWidget() {
    const textStyle = TextStyle(color: Colors.red);
    final Widget widget = DescriptionMessageWidget(
      descriptionMessageStateProvider:
          UserPageState.attentionMessageStateProvider,
      textStyle: textStyle,
    );

    return widget;
  }

  // userNameField
  static Widget userNameField() {
    //
    final Widget widget = Consumer(builder: (context, ref, child) {
      final nickNameFieldStateNotifierProvider =
          ref.watch(UserPageState.nickNameFieldStateNotifierProviderOfProvider);

      return NameFieldWidget(
        nameFieldStateNotifierProvider: nickNameFieldStateNotifierProvider,
      );
    });

    return widget;
  }

  // userUpdateButton
  static Widget userUpdateButton() {
    //
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        return OnSubmitButtonWidget(
          onSubmitButtonStateNotifierProvider: ref.watch(
              UserPageState.userUpdateOnSubmitButtonStateNotifierProvider),
        );
      },
    );

    return widget;
  }

  static Widget updateUserProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final updateUserProgressStateNotifierProvider = ref.watch(
          UserPageState.updateUserProgressStateNotifierProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider: updateUserProgressStateNotifierProvider,
      );
    });

    return widget;
  }
}
