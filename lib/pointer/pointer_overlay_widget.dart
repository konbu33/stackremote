import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../user/domain/user.dart';
import '../user/user.dart';

import 'pointer_overlay_state.dart';
import 'pointer_positioned_widget.dart';

class PointerOverlayWidget extends HookConsumerWidget {
  const PointerOverlayWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointerOverlayStateNotifierProvider);

    // final notifier = ref.read(pointerOverlayStateNotifierProvider.notifier);

    // final usersStream = ref.read(usersStreamProvider);

    final userStreamList = ref.watch(userStreamListProvider) ?? [];

    List<Widget> userWidgetList = [];

    userStreamList.map(
      (userStream) {
        return userStream.when<Widget>(
          loading: () => const Text("usersStream loading..."),
          error: (error, stackTrace) => const Text("error"),
          data: (user) {
            if (user.isOnLongPressing) {
              final widget = PointerPositionedWidget(
                dx: user.pointerPosition.dx,
                dy: user.pointerPosition.dy,
                nickName: user.nickName,
                email: user.email,
                comment: user.comment,
              );

              userWidgetList.add(widget);
            }
            return const Text("success get data");
          },
        );
      },
    ).toList();

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        // 画面タップすることで、TextFormFieldからフォーカスを外せるようにする。
        onTap: () => state.focusNode.unfocus(),

        // ロングタップすることで、ポイン表示開始
        onLongPressStart: (event) async {
          // notifier.changeOnLongPress(isOnLongPressing: true);
          // notifier.updatePosition(event.localPosition);

          // // DBのポインタ情報を更新
          // final pointerOerlayerState =
          //     ref.watch(pointerOverlayStateNotifierProvider);

          final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

          userUpdateUsecase(
            isOnLongPressing: true,
            pointerPosition: event.localPosition,
          );

          // userUpdateUsecase(
          //   isOnLongPressing: pointerOerlayerState.isOnLongPressing,
          //   pointerPosition: pointerOerlayerState.pointerPosition,
          // );
        },

        // ロングタップ中は、ポインタ表示
        onLongPressMoveUpdate: (event) async {
          // notifier.updatePosition(event.localPosition);

          // // DBのポインタ情報を更新
          // final pointerOerlayerState =
          //     ref.watch(pointerOverlayStateNotifierProvider);

          final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

          userUpdateUsecase(
            pointerPosition: event.localPosition,
          );

          // userUpdateUsecase(
          //   pointerPosition: pointerOerlayerState.pointerPosition,
          // );
        },

        child: Container(
          // Container内にポインタが表示される。
          // ContainerのサイズをScaffoldの範囲に合わせるためにcolor指指。
          // この点は改善できそう。
          color: Colors.transparent,
          child: Stack(
            children: [
              child,
              // childの上位レイヤーにポインを表示
              // if (state.isOnLongPressing) const PointerPositionedWidget(),

              Stack(children: userWidgetList),

              // Stack(
              //   children: userStreamList.map(
              //     (userStream) {
              //       return userStream.when<Widget>(
              //         loading: () => const Text("usersStream loading..."),
              //         error: (error, stackTrace) => const Text("error"),
              //         data: (user) {
              //           return user.isOnLongPressing
              //               ? PointerPositionedWidget(
              //                   dx: user.pointerPosition.dx,
              //                   dy: user.pointerPosition.dy,
              //                   nickName: user.nickName,
              //                 )
              //               : Container(color: Colors.transparent);

              //           // Text("$data");
              //         },
              //       );
              //     },
              //   ).toList(),
              // ),

              // usersStream.when(
              //   // loading: () => const CircularProgressIndicator(),
              //   loading: () => const Text("usersStream loading..."),
              //   error: (error, stackTrace) => const Text("error"),
              //   data: (data) {
              //     final pointerPositionedWidgets = data.users.map((user) {
              //       // 各user単位で更新をサブスクライブ
              //       final userStream =
              //           ref.watch(userStreamProviderFiamiy(user.email));

              //       // final userStreamProvider = StreamProvider((ref) {
              //       //   final rtcChannelState = ref.watch(
              //       //       RtcChannelStateNotifierProviderList
              //       //           .rtcChannelStateNotifierProvider);

              //       //   return FirebaseFirestore.instance
              //       //       .collection('channels')
              //       //       .doc(rtcChannelState.channelName)
              //       //       .collection('users')
              //       //       .doc(user.email)
              //       //       .snapshots();
              //       // });

              //       // final userStream = ref.watch(userStreamProvider);

              //       return userStream.when(
              //         // loading: () => const CircularProgressIndicator(),
              //         loading: () => const Text("userStream loading..."),
              //         error: (error, stackTrace) => const Text("error"),
              //         data: (data) {
              //           return user.isOnLongPressing
              //               ? PointerPositionedWidget(
              //                   dx: user.pointerPosition.dx,
              //                   dy: user.pointerPosition.dy,
              //                   nickName: user.nickName,
              //                 )
              //               : const SizedBox();
              //         },
              //       );
              //     });

              //     return Stack(
              //       children: pointerPositionedWidgets.toList(),
              //     );

              //     // return ListView.builder(
              //     //   itemCount: data.users.length,
              //     //   itemBuilder: (context, index) {
              //     //     // final i = data.users.length - (index + 1);
              //     //     final user = data.users[index];

              //     //     return user.isOnLongPressing
              //     //         ? PointerPositionedWidget(
              //     //             dx: user.pointerPosition.dx,
              //     //             dy: user.pointerPosition.dy,
              //     //             nickName: user.nickName,
              //     //           )
              //     //         : const SizedBox();
              //     //   },
              //     // );
              //   },
              // ),

              // // debug: ポインタの位置を表示
              // Text(
              //     "x:${(state.pointerPosition.dx.round())}, y:${state.pointerPosition.dy.round()}"),
            ],
          ),
        ),
      ),
    );
  }
}
