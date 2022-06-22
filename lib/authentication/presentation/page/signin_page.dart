import 'package:go_router/go_router.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers.dart';
import '../widget/background_image_widget.dart';
import '../widget/base_layout_widget.dart';
import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_widget.dart';
import '../widget/signup_widget.dart';
import 'package:flutter/material.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.read(Providers.useAuthProvider);

    final state = ref.watch(Providers.SignInPageNotifierProvider);
    state.useAuth();
    // final notifier = ref.watch(Providers.SignInPageNotifierProvider.notifier);

    return BackgroundImageWidget(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(state.title),
          actions: const [
            SignUpWidget(),
          ],
        ),
        body: BaseLayoutWidget(
          children: [
            Form(
              key: state.loginFormState.loginFormKey.value,
              // key: GlobalKey<FormState>(),
              child: Column(
                children: [
                  LoginIdFieldWidget(
                    state: state.loginIdFieldState,
                    notifier: state.loginIdFieldStateNotifier,
                  ),
                  const SizedBox(height: 30),
                  PasswordFieldWidget(
                    state: state.passwordFieldState,
                    notifier: state.passwordFieldStateNotifier,
                  ),
                  const SizedBox(height: 40),
                  LoginSubmitWidget(
                    name: state.title,
                    state: state.loginSubmitState,
                    onSubmit: state.onSubmit,
                    // onSubmit: state.loginSubmitState.authenticationService.signIn,
                  ),
                  // const SizedBox(height: 40),
                  // const SignUpWidget(),
                  // const SizedBox(height: 40),
                  // const TodoListWidget(),
                  // const LoggedInToggleWidget(),
                  // const SizedBox(height: 40),
                  // const SignOutWidget(),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       context.go('/home');
                  //     },
                  //     child: Text("go home")),
                  // const SizedBox(height: 40),
                  // BoldBorderTextFormField(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
