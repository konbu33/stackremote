import 'package:flutter/material.dart';

class VideoMuteWidget extends StatelessWidget {
  const VideoMuteWidget({super.key, required this.nickName});

  final String nickName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Text(nickName),
    );
  }
}
