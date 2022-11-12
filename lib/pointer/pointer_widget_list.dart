import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../user/domain/user.dart';
import 'pointer_positioned_widget.dart';
import 'pointer_provider.dart';

class PointerWidgetList extends StatelessWidget {
  const PointerWidgetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userStreamList = ref.watch(pointerProvider);

      if (userStreamList.isEmpty) return Stack(children: const []);

      userStreamList as List<AsyncValue<User>>;

      List<Widget?> pointerWidgetListNullable =
          userStreamList.map((userStream) {
        //

        return userStream.when(
          loading: () {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text("loading : pointer info"),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text("error : load pointer info"),
                ],
              ),
            );
          },
          data: (user) {
            if (user.isOnLongPressing) {
              final widget = PointerPositionedWidget(
                dx: user.pointerPosition.dx,
                dy: user.pointerPosition.dy,
                nickName: user.nickName,
                email: user.email,
                comment: user.comment,
              );
              return widget;
            }
            return null;
          },
        );
      }).toList();

      // nullを除去
      final List<Widget> pointerWidgetList =
          pointerWidgetListNullable.whereType<Widget>().toList();

      return Stack(children: pointerWidgetList);

      //
    });
  }
}
