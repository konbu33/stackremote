import 'package:flutter/material.dart';

class ScaffoldBodyBaseLayoutWidget extends StatelessWidget {
  const ScaffoldBodyBaseLayoutWidget({
    super.key,
    required this.children,
    required this.focusNodeList,
  });

  final List<Widget> children;
  final List<FocusNode> focusNodeList;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 700,
        ),
        child: GestureDetector(
          onTap: () {
            for (final focusNode in focusNodeList) {
              focusNode.unfocus();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ScaffoldBodyBaseLayoutWidgetParts.mainWidget(children),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScaffoldBodyBaseLayoutWidgetParts {
  // packageInfoWidget
  static Widget mainWidget(List<Widget> children) {
    Widget widget = Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );

    return widget;
  }
}
