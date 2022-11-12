import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/common.dart';
import '../user/domain/user.dart';
import '../user/user.dart';

// import 'pointer_overlay_provider_stream_transformer.dart';
import 'pointer_overlay_provider_await_for.dart';

import 'pointer_overlay_state.dart';
import 'pointer_positioned_widget.dart';

class PointerOverlayWidget extends StatefulHookConsumerWidget {
  const PointerOverlayWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  ConsumerState<PointerOverlayWidget> createState() =>
      _PointerOverlayWidgetState();
}

class _PointerOverlayWidgetState extends ConsumerState<PointerOverlayWidget> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pointerOverlayStateNotifierProvider);

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        // 画面タップすることで、TextFormFieldからフォーカスを外せるようにする。
        onTap: () => state.focusNode.unfocus(),

        // ロングタップすることで、ポイン表示開始
        onLongPressStart: (event) async {
          // DBのポインタ情報を更新
          final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

          userUpdateUsecase(
            isOnLongPressing: true,
            pointerPosition: event.localPosition,
          );
        },

        // ロングタップ中は、ポインタ表示
        onLongPressMoveUpdate: (event) async {
          // DBのポインタ情報を更新
          final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

          userUpdateUsecase(
            pointerPosition: event.localPosition,
          );
        },

        child: Container(
          // Container内にポインタが表示される。
          // ContainerのサイズをScaffoldの範囲に合わせるためにcolor指指。
          // この点は改善できそう。
          color: Colors.transparent,
          child: Stack(
            children: [
              widget.child,
              // // childの上位レイヤーにポインを表示
              // if (state.isOnLongPressing) const PointerPositionedWidget(),

              PointerOverlayWidgetParts.buildPointerLayer(),

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

class PointerOverlayWidgetParts {
  PointerOverlayWidgetParts();

  static Widget buildPointerLayer() {
    return Consumer(builder: (context, ref, child) {
      // List<Widget> userWidgetList = [];
      // final userStreamList = ref.watch(userStreamListProvider) ?? [];
      // userStreamList.map(
      //   (userStream) {
      //     return userStream.when<Widget>(
      //       loading: () => const Text("usersStream loading..."),
      //       error: (error, stackTrace) => const Text("error"),
      //       data: (user) {
      //         if (user.isOnLongPressing) {
      //           final widget = PointerPositionedWidget(
      //             dx: user.pointerPosition.dx,
      //             dy: user.pointerPosition.dy,
      //             nickName: user.nickName,
      //             email: user.email,
      //             comment: user.comment,
      //           );

      //           userWidgetList.add(widget);
      //         }
      //         return const Text("success get data");
      //       },
      //     );
      //   },
      // ).toList();

      final userStreamList = ref.watch(awaitForUserStreamListProvider);

      if (userStreamList.isEmpty) return Stack(children: const []);

      userStreamList as List<AsyncValue<User>>;

      List<Widget?> userWidgetListNullable = userStreamList.map((userStream) {
        //

        return userStream.when(
          loading: () {
            sleep(const Duration(seconds: 2));
            logger.d("yyyy : loadding....");
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
            logger.d("yyyy : error....");
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

      final List<Widget> userWidgetList =
          userWidgetListNullable.whereType<Widget>().toList();

      return Stack(children: userWidgetList);

      //
    });
  }
}
