import 'package:flutter/material.dart';

import 'package_info_widget.dart';

class ScaffoldBodyBaseLayoutWidget extends StatelessWidget {
  const ScaffoldBodyBaseLayoutWidget({
    Key? key,
    required this.children,
    required this.focusNodeList,
  }) : super(key: key);

  final List<Widget> children;
  final List<FocusNode> focusNodeList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          ScaffoldBodyBaseLayoutWidgetParts.packageInfoWidget(),
        ],
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

  // packageInfoWidget
  static Widget packageInfoWidget() {
    Widget widget = const PackageInfoWidget();
    return widget;
  }
}
