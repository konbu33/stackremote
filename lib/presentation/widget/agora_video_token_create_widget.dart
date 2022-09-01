import 'package:flutter/material.dart';
import 'package:stackremote/presentation/page/agora_video_page_state.dart';

class AgoraVideoTokenCreateWidget extends StatelessWidget {
  const AgoraVideoTokenCreateWidget({
    Key? key,
    required this.state,
    required this.notifier,
  }) : super(key: key);

  final AgoraVideoPageState state;
  final AgoraVideoPageStateNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        print("riverpod : ");
        await notifier.createToken();
        // final token = await notifier.createToken();
        // notifier.updateToken(token);
      },
      child: Text("Create Token : ${state.token.substring(0, 1)}"),
    );
  }
}
