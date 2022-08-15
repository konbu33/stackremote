import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/presentation/widget/auth_widget.dart';

import '../../common/use_auth.dart';
import '../widget/background_image_widget.dart';
import '../widget/base_layout_widget.dart';

import 'signin_page_state.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInPageStateNotifierProvider);
    // final useAuth = ref.watch(useAuthProvider);
    // useAuth();

    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.loginSubmitWidgetName),
          actions: [
            state.singUpWidget,
          ],
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
                  const SizedBox(height: 40),
                  state.userInformationWidget,
                  const AuthWidget(child: Text("getDataOK")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
