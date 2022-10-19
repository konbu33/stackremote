import 'package:flutter/material.dart';

import '../../../authentication/presentation/page/change_password_page.dart';
import '../../../common/design/design_background_image_layer.dart';
import '../../../user/presentation/page/user_page.dart';

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
                ListTile(
                  title: const Text("パスワード変更"),
                  onTap: () {
                    // Drawerを閉じる
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ChangePasswordPage();
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text("ユーザ情報"),
                  onTap: () {
                    // context.go("/home");
                    // context.push("/user");

                    // Drawerを閉じる
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const UserPage();
                        },
                      ),
                    );

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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
