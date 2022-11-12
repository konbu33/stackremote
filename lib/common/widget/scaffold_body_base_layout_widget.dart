import 'package:flutter/material.dart';

import '../common.dart';

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
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
