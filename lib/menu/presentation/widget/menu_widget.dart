import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stackremote/user/user_routing_layer.dart';

import '../../../home_page.dart';
import '../../../user/presentation/page/user_page.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text("Header"),
          ),
          ListTile(
            title: const Text("User"),
            onTap: () {
              // context.go("/home");

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
    );
  }
}
