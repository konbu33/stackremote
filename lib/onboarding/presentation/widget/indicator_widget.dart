import 'package:flutter/material.dart';

class PageIndicatorStyle {
  final double? width;
  final Color? activeColor;
  final Color? inactiveColor;
  final Size? activeSize;
  final Size? inactiveSize;

  const PageIndicatorStyle({
    this.width,
    this.activeColor,
    this.inactiveColor,
    this.activeSize,
    this.inactiveSize,
  });
}

class PageIndicatorWidget extends StatelessWidget {
  /// No of dot to be appeared should be equal to
  /// the length of the [List<OnBoardModel>]
  final int count;

  /// Active page
  final int activePage;

  /// styling [PageIndicatorStyle]
  final PageIndicatorStyle? pageIndicatorStyle;

  const PageIndicatorWidget({
    super.key,
    required this.count,
    required this.activePage,
    this.pageIndicatorStyle,
  });

  @override
  Widget build(BuildContext context) {
    final dots = List.generate(count, _dotBuilder);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutSine,
      width: pageIndicatorStyle!.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dots,
      ),
    );
  }

  Widget _dotBuilder(index) {
    final activeSize = pageIndicatorStyle!.activeSize;
    final inactiveSize = pageIndicatorStyle!.inactiveSize;

    return index == activePage
        ? Container(
            width: activeSize!.width,
            height: activeSize.height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pageIndicatorStyle!.activeColor,
            ),
          )
        : Container(
            width: inactiveSize!.width,
            height: inactiveSize.height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pageIndicatorStyle!.inactiveColor,
            ),
          );
  }
}
