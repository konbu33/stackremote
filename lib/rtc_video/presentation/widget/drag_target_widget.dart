import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef VideoSubLayerAlignmentProvider
    = AutoDisposeStateProvider<AlignmentDirectional>;

class DragTargetWidget extends StatelessWidget {
  const DragTargetWidget({
    Key? key,
    required this.videoSubLayerAlignmentProvider,
  }) : super(key: key);

  final VideoSubLayerAlignmentProvider videoSubLayerAlignmentProvider;

  @override
  Widget build(BuildContext context) {
    //
    final dragTargetCreatorProvider = Provider((ref) {
      DragTarget dragTargetCreator(AlignmentDirectional alignmentDirectional) {
        return DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return const Center();
          },
          onAccept: (data) {
            ref
                .read(videoSubLayerAlignmentProvider.notifier)
                .update((state) => alignmentDirectional);
          },
        );
      }

      return dragTargetCreator;
    });

    return Consumer(
      builder: ((context, ref, child) {
        final dragTargetCreator = ref.watch(dragTargetCreatorProvider);

        final dragTargetTopStart =
            dragTargetCreator(AlignmentDirectional.topStart);

        final dragTargetTopEnd = dragTargetCreator(AlignmentDirectional.topEnd);

        final dragTargetBottomStart =
            dragTargetCreator(AlignmentDirectional.bottomStart);

        final dragTargetBottomEnd =
            dragTargetCreator(AlignmentDirectional.bottomEnd);

        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: dragTargetTopStart),
                  Expanded(child: dragTargetTopEnd),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: dragTargetBottomStart),
                  Expanded(child: dragTargetBottomEnd),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
