import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/pointer_state_list.dart';
import 'pointer_positioned_widget.dart';

class PointerWidgetList extends StatelessWidget {
  const PointerWidgetList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      //

      final pointerStateList = ref.watch(pointerStateListStateNotifierProvider
          .select((value) => value.pointerStateList));

      if (pointerStateList.isEmpty) {
        return Stack(children: const []);
      }

      List<Widget?> pointerWidgetListNullable =
          pointerStateList.map((pointerState) {
        //
        if (pointerState.isOnLongPressing) {
          final pointerPositionedWidget = PointerPositionedWidget(
            comment: pointerState.comment,
            dx: pointerState.displayPointerPosition.dx,
            dy: pointerState.displayPointerPosition.dy,
            email: pointerState.email,
            nickName: pointerState.nickName,
          );

          return pointerPositionedWidget;
        }

        //
        return null;
      }).toList();

      // nullを除去
      final pointerWidgetList =
          pointerWidgetListNullable.whereType<Widget>().toList();

      return Stack(children: pointerWidgetList);

      //
    });
  }
}
