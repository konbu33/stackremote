import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

abstract class RtcVideoRepository {
  const RtcVideoRepository({
    required this.rtcEngine,
  });

  final RtcEngine rtcEngine;

  Future<void> androidPermissionRequest();

  Future<void> channelJoin({
    required String token,
    required String channelName,
    required int optionalUid,
  });

  Future<void> channelLeave();

  Future<void> muteLocalAudio(bool isMute);
  Future<void> muteLocalVideo(bool isMute);
  Future<void> muteRemoteVideo({
    required int remoteUid,
    required bool isMute,
  });

  Future<void> setVideoEncoderConfiguration(Size videoDimensions);

  Future<void> switchCamera();

  Future<String> createRtcIdToken({
    required String channelName,
    required int localUid,
    required String account,
    required String rtcIdTokenType,
    required String role,
    required int privilegeExpireTime,
  });
}
