import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/use_auth.dart';
import '../widget/background_image_widget.dart';
import '../widget/base_layout_widget.dart';

import 'signup_page_state.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpPageStateNotifierProvider);
    final useAuth = ref.read(useAuthProvider);
    useAuth();

    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.loginSubmitWidgetName),
        ),
        body: BaseLayoutWidget(
          children: [
            Form(
              key: GlobalKey<FormState>(),
              child: Column(
                children: [
                  state.loginIdField,
                  const SizedBox(height: 30),
                  state.passwordField,
                  const SizedBox(height: 40),
                  state.loginSubmitWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
