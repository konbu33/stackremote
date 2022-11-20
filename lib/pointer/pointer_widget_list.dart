import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/users.dart';
import 'package:stackremote/user/user.dart';
// import 'package:stackremote/pointer/pointer_overlay_state.dart';

import '../common/common.dart';
// import '../user/domain/user.dart';
import 'pointer_positioned_widget.dart';
// import 'pointer_provider.dart';
import 'pointer_provider.dart';
import 'pointer_state_list.dart';

class PointerWidgetList extends StatelessWidget {
  const PointerWidgetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      // final userStreamList = ref.watch(pointerProvider);
      // final userStreamList = ref.watch(pointerStateProvider);

      // final pointerOverlayState =
      //     ref.watch(pointerStateListStateNotifierProvider);

      // logger.d(" yyy1 : ${pointerOverlayState.pointerStateList}");

      // if (pointerOverlayState.pointerStateList.isEmpty) {
      //   return Stack(children: const []);
      // }

      final pointerStateList = ref.watch(pointerStateProvider);

      if (pointerStateList.isEmpty) {
        return Stack(children: const []);
      }

      List<Widget?> pointerWidgetListNullable =
          pointerStateList.map((pointerState) {
        if (pointerState.isOnLongPressing) {
          final widget = PointerPositionedWidget(
            comment: pointerState.comment,
            dx: pointerState.pointerPosition.dx,
            dy: pointerState.pointerPosition.dy,
            email: pointerState.email,
            nickName: pointerState.nickName,
          );
          return widget;
        }
        return null;
      }).toList();

      // final usersState = ref.watch(usersStateNotifierProvider);

      // if (usersState.users.isEmpty) {
      //   return Stack(children: const []);
      // }

      // // userStreamList as List<AsyncValue<User>>;

      // // List<Widget?> pointerWidgetListNullable =
      // List<Widget?> pointerWidgetListNullable =
      //     // pointerOverlayState.pointerStateList.map((pointerState) {
      //     usersState.users.map((pointerState) {
      //   if (pointerState.isOnLongPressing) {
      //     final widget = PointerPositionedWidget(
      //       comment: pointerState.comment,
      //       dx: pointerState.pointerPosition.dx,
      //       dy: pointerState.pointerPosition.dy,
      //       email: pointerState.email,
      //       nickName: pointerState.nickName,
      //     );
      //     return widget;
      //   }
      //   return null;
      // }).toList();

      //

      //   return userStream.when(
      //     loading: () {
      //       return Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: const [
      //             CircularProgressIndicator(),
      //             Text("loading : pointer info"),
      //           ],
      //         ),
      //       );
      //     },
      //     error: (error, stackTrace) {
      //       return Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: const [
      //             CircularProgressIndicator(),
      //             Text("error : load pointer info"),
      //           ],
      //         ),
      //       );
      //     },
      //     data: (user) {
      //       if (user.isOnLongPressing) {
      //         final widget = PointerPositionedWidget(
      //           dx: user.pointerPosition.dx,
      //           dy: user.pointerPosition.dy,
      //           nickName: user.nickName,
      //           email: user.email,
      //           comment: user.comment,
      //         );
      //         return widget;
      //       }
      //       return null;
      //     },
      //   );
      // }).toList();

      // nullを除去
      final List<Widget> pointerWidgetList =
          pointerWidgetListNullable.whereType<Widget>().toList();

      return Stack(children: pointerWidgetList);

      //
    });
  }
}













// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../user/domain/user.dart';
// import 'pointer_positioned_widget.dart';
// import 'pointer_provider.dart';

// class PointerWidgetList extends StatelessWidget {
//   const PointerWidgetList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, ref, child) {
//       final userStreamList = ref.watch(pointerProvider);

//       if (userStreamList.isEmpty) return Stack(children: const []);

//       userStreamList as List<AsyncValue<User>>;

//       List<Widget?> pointerWidgetListNullable =
//           userStreamList.map((userStream) {
//         //

//         return userStream.when(
//           loading: () {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   CircularProgressIndicator(),
//                   Text("loading : pointer info"),
//                 ],
//               ),
//             );
//           },
//           error: (error, stackTrace) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   CircularProgressIndicator(),
//                   Text("error : load pointer info"),
//                 ],
//               ),
//             );
//           },
//           data: (user) {
//             if (user.isOnLongPressing) {
//               final widget = PointerPositionedWidget(
//                 dx: user.pointerPosition.dx,
//                 dy: user.pointerPosition.dy,
//                 nickName: user.nickName,
//                 email: user.email,
//                 comment: user.comment,
//               );
//               return widget;
//             }
//             return null;
//           },
//         );
//       }).toList();

//       // nullを除去
//       final List<Widget> pointerWidgetList =
//           pointerWidgetListNullable.whereType<Widget>().toList();

//       return Stack(children: pointerWidgetList);

//       //
//     });
//   }
// }
