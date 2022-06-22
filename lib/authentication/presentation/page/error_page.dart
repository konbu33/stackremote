import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../widget/loggedin_toggle_widget.dart';
import '../../application/providers.dart';
import '../widget/base_layout_widget.dart';
import '../widget/signout_widget.dart';

class ErrorPage extends HookConsumerWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useAuth = ref.read(Providers.useAuthProvider);
    useAuth();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Error Page"),
        actions: const [
          SignOutWidget(),
        ],
      ),
      body: const BaseLayoutWidget(
        children: [
          Text("Error Page Body"),
          // LoggedInToggleWidget(),
          // SignOutWidget(),
        ],
      ),
    );
  }
}
