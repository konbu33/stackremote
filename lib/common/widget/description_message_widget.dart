import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DescriptionMessageWidget extends StatelessWidget {
  const DescriptionMessageWidget({
    super.key,
    required this.descriptionMessageStateProvider,
    this.textStyle,
  });

  final AutoDisposeStateProvider<String> descriptionMessageStateProvider;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final descriptionMessageState =
          ref.watch(descriptionMessageStateProvider);

      if (descriptionMessageState.isEmpty) return const SizedBox();

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              descriptionMessageState,
              style: textStyle,
            ),
          ],
        ),
      );
    });
  }
}
