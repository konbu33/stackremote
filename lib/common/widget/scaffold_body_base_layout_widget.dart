import 'package:flutter/material.dart';

class ScaffoldBodyBaseLayoutWidget extends StatelessWidget {
  const ScaffoldBodyBaseLayoutWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
