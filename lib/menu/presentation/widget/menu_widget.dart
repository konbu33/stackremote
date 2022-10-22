import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/menu/menu.dart';

import '../../../authentication/authentication.dart';
import '../../../common/common.dart';
import 'menu_state.dart';

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
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Text("メニュー"),
                ),
                Consumer(
                  builder: ((context, ref, child) {
                    final notifier =
                        ref.read(menuStateNotifierProvider.notifier);

                    return ListTile(
                      title: const Text("パスワード変更"),
                      onTap: () {
                        // Drawerを閉じる
                        Navigator.pop(context);

                        notifier
                            .changeCurrentMenu(OperationMenu.changePassword);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return const ChangePasswordPage();
                        //     },
                        //   ),
                        // );
                      },
                    );
                  }),
                ),
                Consumer(builder: ((context, ref, child) {
                  final notifier = ref.read(menuStateNotifierProvider.notifier);

                  return ListTile(
                    title: const Text("ユーザ情報"),
                    onTap: () {
                      // context.push("/user");

                      // Drawerを閉じる
                      Navigator.pop(context);

                      notifier.changeCurrentMenu(OperationMenu.user);
                      // currentMmenuItem = MenuItem.userPage;

                      // context.go("/agoravideochanneljoin/user");
                      // context.push("/agoravideochanneljoin/user");
                      // context.go("/user");
                      // context.push("/user");

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return const UserPage();
                      //     },
                      //   ),
                      // );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return const HomePage();
                      //     },
                      //   ),
                      // );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return const UserRoutingLayer();
                      //     },
                      //   ),
                      // );

                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return const UserRoutingLayer();
                      //     },
                      //   ),
                      // );
                    },
                  );
                })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
