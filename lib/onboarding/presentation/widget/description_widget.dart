import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'description_widget_state.dart';

class DescriptionWidget extends ConsumerWidget {
  DescriptionWidget({
    super.key,
    required this.descriptionWidgetState,
  });

  final DescriptionWidgetState descriptionWidgetState;

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 45.0,
                ),
                constraints: const BoxConstraints(maxWidth: 450),
                child: SvgPicture.asset(
                  descriptionWidgetState.imagePath,
                  height: 300,
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                alignment: Alignment.centerLeft,
                constraints: const BoxConstraints(maxWidth: 450),
                child: Text(
                  descriptionWidgetState.title,
                  style: const TextStyle(fontSize: 23, letterSpacing: 1.0),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 45.0, vertical: 10.0),
                alignment: Alignment.topLeft,
                constraints: BoxConstraints(
                  maxWidth: 450,
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: Text(
                  descriptionWidgetState.description,
                  textAlign: TextAlign.left,
                  style: const TextStyle(letterSpacing: 1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
