import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../pointer/pointer.dart';
import '../../../user/user.dart';

class RtcVideoControlWidget extends StatelessWidget {
  const RtcVideoControlWidget({super.key});

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
                const DrawerHeader(child: Text("コントローラ")),
                RtcVideoControlWidgetParts.userColorWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RtcVideoControlWidgetParts {
  // userColorWidget
  static Widget userColorWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      // final userColorList = ref.watch(userColorListProvider);

      final userColorWidgetList = UserColor.values.map((userColor) {
        return GestureDetector(
          onTap: () {
            // Drawerを閉じる
            Navigator.pop(context);

            // color変更
            ref
                .read(pointerStateNotifierProvider.notifier)
                .updateUserColor(userColor);
          },
          child: Container(
            decoration: BoxDecoration(
              color: userColor.color,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }).toList();

      final userColorWidget = Builder(builder: (context) {
        const double gridViewHeight = 250;
        const double spacing = 20;

        return Column(
          children: [
            const ListTile(title: Text("色の選択")),
            SizedBox(
              height: gridViewHeight,
              child: GridView.count(
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                padding: const EdgeInsets.all(spacing),
                crossAxisCount: 3,
                children: userColorWidgetList,
              ),
            ),
          ],
        );
      });

      // Widget gradientWidget(Widget child) {
      //   return Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [
      //           Colors.grey.withOpacity(0),
      //           Colors.grey.withOpacity(0.1),
      //         ],
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //       ),
      //     ),
      //     child: child,
      //   );
      // }

      return gradientWidget(userColorWidget);
    });

    return widget;
  }

  // gradientWidget
  static Widget gradientWidget(Widget child) {
    Widget widget = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0),
            Colors.grey.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );

    //

    return widget;
  }
}
