import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'authentication/presentation/widget/signout_widget.dart';
import 'user.dart';
import 'user_detail_page.dart';
import 'user_detail_page_state.dart';
import 'user_page_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userPageStateControllerProvider);
    final notifier = ref.read(userDetailPageStateControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: UserPageWidgets.pageTitleWidget(state),
        actions: [
          UserPageWidgets.userAddButton(state, notifier),
          UserPageWidgets.signOutButton(),
        ],
      ),
      body: Column(
        children: [
          UserPageWidgets.userListWidget(state),
        ],
      ),
    );
  }
}

class UserPageWidgets {
  // pageTitleWidget
  static Widget pageTitleWidget(UserPageState state) {
    final Widget widget = Text(state.pageTitle);

    return widget;
  }

  //  userAddButton
  static Widget userAddButton(
    UserPageState state,
    UserDetailPageStateController notifier,
  ) {
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        return IconButton(
          onPressed: () async {
            notifier.setUserAddOnSubmit();
            notifier.clearUserEmailAndPassword();
            await showModalBottomSheet(
              context: context,
              builder: (context) {
                return const UserDetailPage();
              },
            );
            notifier.clearUserEmailAndPassword();
          },
          icon: const Icon(Icons.person_add),
          tooltip: state.userAddButtonName,
        );
      },
    );

    return widget;
  }

  // signOutButton
  static Widget signOutButton() {
    const Widget widget = SignOutWidget();

    return widget;
  }

  static Widget userListWidget(
    UserPageState state,
  ) {
    final widget = Consumer(
      builder: (context, ref, child) {
        final usersStream = ref.watch(state.usersStreamProvider);
        return usersStream.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stacktrace) => const Text("error"),
          data: (data) {
            return Flexible(
              child: ListView.builder(
                  itemCount: data.users.length,
                  itemBuilder: (context, index) {
                    final user = data.users[index];
                    final email = user.email;
                    final userId = user.userId.value.toString();

                    return ListTile(
                      title: Text(email),
                      subtitle: Text(userId),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          state.userDeleteUseCase.execute(userId);
                        },
                      ),
                      onTap: () async {
                        final User user =
                            await state.userFindByIdUseCase.execute(userId);
                        final notifier = ref.read(
                            userDetailPageStateControllerProvider.notifier);
                        notifier.setUserEmailAndPassword(user);
                        notifier.setUserUpdateOnSubmit(user);
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const UserDetailPage();
                          },
                        );
                        notifier.clearUserEmailAndPassword();
                      },
                    );
                  }),
            );
          },
        );
      },
    );

    return widget;
  }
}
