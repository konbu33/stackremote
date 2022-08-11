import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/presentation/widget/signout_widget.dart';
import 'package:stackremote/user_page_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Reader read = ref.read;
    final Reader watch = ref.watch;
    final state = watch(userPageStateControllerProvider);
    final notifier = read(userPageStateControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: state.pageTitleWidget,
        actions: [
          state.userAddButton,
          const SignOutWidget(),
        ],
      ),
      body: Column(
        children: [
          state.userListWidget,
          TextFormField(
            controller: TextEditingController(),
            onChanged: (t) async {
              print("text : $t");
              try {
                await state.userFindByIdUseCase.execute(t);
              } on FirebaseException catch (e) {
                print("e1 : $e");
              } catch (e, s) {
                print("e2 : $e , s2: $s");
              }
            },
          )
        ],
      ),
    );
  }
}
