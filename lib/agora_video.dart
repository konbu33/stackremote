import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stackremote/custom_mouse_cursor/custom_mouse_cursor_overlay.dart';
import 'package:stackremote/providers.dart';
// import 'package:stackremote/channel_create_widget.dart';
import 'token_create_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Define App ID and Token
final String appId = dotenv.get("APP_ID");
final String token = dotenv.get("Token");
final String roomName = dotenv.get("RoomName");
// const RoomName = '123';

class AgoraVideoPage extends StatefulWidget {
  @override
  _AgoraVideoPageState createState() => _AgoraVideoPageState();
}

// App state class
class _AgoraVideoPageState extends State<AgoraVideoPage> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  // Init the app
  Future<void> initPlatformState() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    // ログ出力
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    print("tempPath : ${tempPath}");

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    print("appDocPath : ${appDocPath}");

    final LogConfig logConfig =
        LogConfig(filePath: "${tempPath}/custom_agora.log");
    // final LogConfig logConfig = LogConfig();
    // LogConfig(filePath: "${tempPath}/custom_agora.log");

    final RtcEngineContext context =
        RtcEngineContext(appId, logConfig: logConfig);

    // Create RTC client instance
    // RtcEngineContext context = RtcEngineContext(appId);
    var engine = await RtcEngine.createWithContext(context);
    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess ${channel} ${uid}');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      print('userJoined ${uid}');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline ${uid}');
      setState(() {
        _remoteUid = 0;
      });
    }));
    // Enable video
    await engine.enableVideo();
    // Join channel with channel name as 123
    try {
      await engine.joinChannel(token, roomName, null, 0);
    } catch (e) {
      print("${e.toString()}");
    }
  }

  Future<void> leaveChannel() async {
    // コンテキスト生成
    final RtcEngineContext context = RtcEngineContext(appId);

    // コンテキスト注入し、エンジン生成
    final RtcEngine engine = await RtcEngine.createWithContext(context);

    // イベントハンドラ定義
    final RtcEngineEventHandler handler = RtcEngineEventHandler(
      leaveChannel: ((RtcStats stats) {
        print("on leave channel ---------- : stats : ${stats.toString()}");
      }),
    );

    // エンジにイベントハンドラ注入
    engine.setEventHandler(handler);

    // チャンネル離脱
    try {
      await engine.leaveChannel();
    } catch (e) {
      print("${e.toString()}");
    }
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter example app ${_joined}'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await initPlatformState();
                    },
                    child: const Text("join channel")),
                ElevatedButton(
                    onPressed: () async {
                      await leaveChannel();
                    },
                    child: const Text("leave channel")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                // ChannelCreateWidget(),
                TokenCreateWidget(),
              ],
            ),
            Flexible(
              child: Stack(
                children: [
                  Center(
                    child:
                        _switch ? _renderRemoteVideo() : _renderLocalPreview(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _switch = !_switch;
                          });
                        },
                        child: Center(
                          child: _switch
                              ? _renderLocalPreview()
                              : _renderRemoteVideo(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // CustomMouseCursorOverlayer(
            //   child: Container(
            //     height: 300,
            //     color: Colors.green[100],
            //     width: double.infinity,
            //     child: () {
            //       return HookConsumer(
            //         builder: ((context, ref, child) {
            //           final state =
            //               ref.watch(Providers.customMouseCursorController);
            //           return Text("state : ${state}");
            //         }),
            //       );
            //     }(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Local video rendering
  Widget _renderLocalPreview() {
    if (_joined && defaultTargetPlatform == TargetPlatform.android ||
        _joined && defaultTargetPlatform == TargetPlatform.iOS) {
      return const RtcLocalView.SurfaceView();
    }

    if (_joined && defaultTargetPlatform == TargetPlatform.windows ||
        _joined && defaultTargetPlatform == TargetPlatform.macOS) {
      return const RtcLocalView.TextureView();
    } else {
      return const Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  // Remote video rendering
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0 && defaultTargetPlatform == TargetPlatform.android ||
        _remoteUid != 0 && defaultTargetPlatform == TargetPlatform.iOS) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
        channelId: roomName,
      );
    }

    if (_remoteUid != 0 && defaultTargetPlatform == TargetPlatform.windows ||
        _remoteUid != 0 && defaultTargetPlatform == TargetPlatform.macOS) {
      return RtcRemoteView.TextureView(
        uid: _remoteUid,
        channelId: roomName,
      );
    } else {
      return const Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }
}
