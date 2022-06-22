import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers.dart';
import '../widget/background_image_widget.dart';
import '../widget/base_layout_widget.dart';
import '../widget/loggedin_toggle_widget.dart';
import '../widget/signout_widget.dart';
import '../widget/todo_list_widget.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useAuth = ref.read(Providers.useAuthProvider);
    useAuth();

    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor.withOpacity(0),
          elevation: 0,
          title: const Text("ホームページ"),
          actions: const [
            SignOutWidget(),
          ],
        ),
        body: const BaseLayoutWidget(
          children: [
            Text("ようこそ"),
            // LoggedInToggleWidget(),
            TodoListWidget(),
            // SignOutWidget(),
          ],
        ),
      ),
    );
  }
}
