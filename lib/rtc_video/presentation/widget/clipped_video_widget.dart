import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../user/user.dart';

class ClippedVideoWidget extends StatelessWidget {
  const ClippedVideoWidget({
    super.key,
    required this.child,
    required this.userColor,
  });

  final Widget child;
  final UserColor userColor;

  @override
  Widget build(BuildContext context) {
    return Consumer(
        child: child,
        builder: (context, ref, child) {
          final remotePreviewSizeProvider =
              StateProvider.autoDispose((ref) => const Size(100, 100));

          final remotePreviewSize = ref.watch(remotePreviewSizeProvider);

          return Container(
            width: remotePreviewSize.width,
            height: remotePreviewSize.height,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                // color: Colors.white24,
                color: userColor.color,
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: child,
            ),
          );
        });
  }
}
