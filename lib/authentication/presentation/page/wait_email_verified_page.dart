import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../usecase/check_email_verified.dart';

import '../widget/login_submit_widget.dart';
import 'wait_email_verified_page_state.dart';

class WaitEmailVerifiedPage extends HookConsumerWidget {
  const WaitEmailVerifiedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(WaitEmailVerifiedPageState.pageTitle),
        actions: [
          WaitEmailVerifiedPageWidgets.signOutIconWidget(),
        ],
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: const [],
        children: [
          Column(
            children: [
              WaitEmailVerifiedPageWidgets.descriptionMessageWidget(),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.sendVerifiyEmailWidget(),
              WaitEmailVerifiedPageWidgets.attentionMessageWidget(),
              const SizedBox(height: 80), // height: 90以上でレイアウトエラー発生する様子。
              WaitEmailVerifiedPageWidgets.checkEmailVerifiedTimerWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class WaitEmailVerifiedPageWidgets {
  //

  // signOutIconWidget
  static Widget signOutIconWidget() {
    //
    final Widget widget = Consumer(
      builder: ((context, ref, child) {
        return AppbarAcitonIconWidget(
          appbarActionIconStateNotifierProvider:
              ref.watch(WaitEmailVerifiedPageState.signOutIconStateProvider),
        );
      }),
    );

    return widget;
  }

  // messageWidget
  static Widget descriptionMessageWidget() {
    //
    final Widget widget = DescriptionMessageWidget(
      descriptionMessageStateProvider:
          WaitEmailVerifiedPageState.descriptionMessageStateProvider,
    );

    return widget;
  }

  // sendVerifiyEmailWidget
  static Widget sendVerifiyEmailWidget() {
    //
    final Widget widget = Consumer(builder: (context, ref, child) {
      return LoginSubmitWidget(
        loginSubmitStateProvider:
            ref.watch(WaitEmailVerifiedPageState.onSubmitStateProvider),
      );
    });

    return widget;
  }

  // attentionMessageWidget
  static Widget attentionMessageWidget() {
    const textStyle = TextStyle(color: Colors.red);

    final Widget widget = Consumer(builder: (context, ref, child) {
      return DescriptionMessageWidget(
        descriptionMessageStateProvider:
            WaitEmailVerifiedPageState.attentionMessageStateProvider,
        textStyle: textStyle,
      );
    });
    return widget;
  }

  // checkEmailVerifiedTimerWidget
  static Widget checkEmailVerifiedTimerWidget() {
    // メールアドレス確認が完了したか否かをポーリング開始

    final Widget widget = Consumer(builder: (context, ref, child) {
      final checkEmailVerifiedUsecase =
          ref.watch(checkEmailVerifiedUsecaseProvider);

      final checkEmailVerifiedTimer = checkEmailVerifiedUsecase();

      checkEmailVerifiedTimer;

      return const SizedBox();
    });
    return widget;
  }
}
