// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../domain/firebase_auth_user.dart';
import '../../../common/common.dart';
import '../widget/appbar_action_icon_widget.dart';
// import '../../../common/widget/scaffold_body_base_layout_widget.dart';

import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_widget.dart';
import 'signin_page_state.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInPageStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.loginSubmitWidgetName),
        actions: [
          SignInPageWidgets.goToSignUpWidget(state),
        ],
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: Column(
              children: [
                SignInPageWidgets.loginIdField(state),
                const SizedBox(height: 30),
                SignInPageWidgets.passwordField(state),
                const SizedBox(height: 40),
                SignInPageWidgets.loginSubmitWidget(state),
                // () {
                //   // final user = ref.watch(userStateNotifierProvider);
                //   final user = ref.watch(firebaseAuthUserStateNotifierProvider);
                //   return SingleChildScrollView(
                //     scrollDirection: Axis.vertical,
                //     child: Text(
                //       "firebaseAuthUser: $user",
                //       maxLines: 10,
                //     ),
                //   );
                // }(),
                // () {
                //   final user = FirebaseAuth.instance.currentUser;
                //   return SingleChildScrollView(
                //     scrollDirection: Axis.vertical,
                //     child: Text(
                //       "currentUser: $user",
                //       maxLines: 10,
                //     ),
                //   );
                // }(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignInPageWidgets {
  // GoTo SignUp Icon Widget
  static Widget goToSignUpWidget(SignInPageState state) {
    final Widget widget = AppbarAcitonIconWidget(
      appbarActionIconStateProvider: state.goToSignUpIconStateProvider,
    );
    return widget;
  }

  // Login Id Field Widget
  static Widget loginIdField(SignInPageState state) {
    final Widget widget = LoginIdFieldWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
    );
    return widget;
  }

  // Password Field Widget
  static Widget passwordField(SignInPageState state) {
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider: state.passwordFieldStateProvider,
    );
    return widget;
  }

  // Login Submit Widget
  static Widget loginSubmitWidget(SignInPageState state) {
    final Widget widget = LoginSubmitWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
      passwordFieldStateProvider: state.passwordFieldStateProvider,
      loginSubmitStateProvider: state.loginSubmitStateProvider,
    );
    return widget;
  }
}
