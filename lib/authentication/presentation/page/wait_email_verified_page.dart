import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../usecase/check_email_verified.dart';
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
              Stack(
                children: [
                  WaitEmailVerifiedPageWidgets.attentionMessageWidget(),
                  WaitEmailVerifiedPageWidgets.signOutProgressWidget(),
                  WaitEmailVerifiedPageWidgets.sendVerifyEmailProgressWidget(),
                ],
              ),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.sendVerifyEmailWidget(),
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

  // descriptionMessageWidget
  static Widget descriptionMessageWidget() {
    //
    final Widget widget = DescriptionMessageWidget(
      descriptionMessageStateProvider:
          WaitEmailVerifiedPageState.descriptionMessageStateProvider,
    );

    return widget;
  }

  // sendVerifyEmailWidget
  static Widget sendVerifyEmailWidget() {
    //
    final Widget widget = Consumer(builder: (context, ref, child) {
      return OnSubmitButtonWidget(
        onSubmitButtonStateNotifierProvider: ref.watch(
            WaitEmailVerifiedPageState
                .sendVerifyEmailOnSubmitStateNotifierProvider),
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

  // signOutProgressWidget
  static Widget signOutProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final signOutProgressStateNotifierProvider = ref.watch(
          WaitEmailVerifiedPageState
              .signOutProgressStateNotifierProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider: signOutProgressStateNotifierProvider,
      );
    });

    return widget;
  }

  // sendVerifyEmailProgressWidget
  static Widget sendVerifyEmailProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final sendVerifyEmailProgressStateNotifierProvider = ref.watch(
          WaitEmailVerifiedPageState
              .sendVerifyEmailProgressStateNotifierProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider:
            sendVerifyEmailProgressStateNotifierProvider,
      );
    });

    return widget;
  }
}
