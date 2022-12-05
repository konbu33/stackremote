import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import 'alert_dialog_widget.dart';

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
                      const DrawerHeader(
                        child: Text("メニュー"),
                      ),
                      ListTile(
                        title: const Text("パスワード変更"),
                        onTap: () {
                          // Drawerを閉じる
                          Navigator.pop(context);

                          context.push('/change_password');
                        },
                      ),
                      ListTile(
                        title: const Text("ユーザ情報"),
                        onTap: () {
                          // Drawerを閉じる
                          Navigator.pop(context);

                          context.push('/user');
                        },
                      ),
                    ],
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ListTile(
                      title: const Text("サービス利用登録解"),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialogWidget();
                          },
                        ).then((value) {
                          // Drawerを閉じる
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
