import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../authentication/authentication.dart';
import '../../../common/common.dart';
import '../../menu.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      child: SizedBox(
        width: 250,
        child: DesignBackgroundImageLayer(
          child: Drawer(
            backgroundColor: Colors.white.withOpacity(0.8),
            // elevation: 0,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const DrawerHeader(child: Text("メニュー")),
                      MenuWidgetParts.goToChangePasswordPageWidget(),
                      MenuWidgetParts.goToUserPageWidget(),
                    ],
                  ),
                ),
                MenuWidgetParts.goToServiceUseCancellationWidget(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuWidgetParts {
  // goToChangePasswordPageWidget
  static Widget goToChangePasswordPageWidget() {
    Widget widget = Consumer(
      builder: (context, ref, child) {
        return ListTile(
          title: const Text("パスワード変更"),
          onTap: () {
            // // Drawerを閉じる
            // Navigator.pop(context);

            // context.push('/change_password');

            ref
                .read(menuRoutingCurrentPathProvider.notifier)
                .update((state) => MenuRoutingPath.changePassword);
          },
        );
      },
    );

    return widget;
  }

  // goToUserPageWidget
  static Widget goToUserPageWidget() {
    Widget widget = Consumer(
      builder: (context, ref, child) {
        return ListTile(
          title: const Text("ユーザ情報"),
          onTap: () {
            // // Drawerを閉じる
            // Navigator.pop(context);

            // context.push('/user');
            ref
                .read(menuRoutingCurrentPathProvider.notifier)
                .update((state) => MenuRoutingPath.user);
          },
        );
      },
    );

    return widget;
  }

  // goToServiceUseCancellationWidget
  static Widget goToServiceUseCancellationWidget() {
    Widget widget = Consumer(
      builder: (context, ref, child) {
        return ListTile(
          title: const Text("サービス利用登録解"),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return const ServiceUseCancellationWidget();
              },
            ).then((value) {
              // Drawerを閉じる
              Navigator.pop(context);
            });
          },
        );
      },
    );

    return widget;
  }
}
