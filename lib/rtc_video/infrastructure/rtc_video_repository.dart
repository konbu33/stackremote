import 'package:agora_rtc_engine/rtc_engine.dart';

abstract class RtcVideoRepository {
  const RtcVideoRepository({
    required this.rtcEngine,
  });

  final RtcEngine rtcEngine;

  Future<void> androidPermissionRequest();

  Future<void> channelJoin({
    required String token,
    required String channelName,
    required String? optionalInfo,
    required int optionalUid,
  });

  Future<void> channelLeave();

  Future<String> createRtcIdToken({
    required String channelName,
    required int localUid,
    required String account,
    required String rtcIdTokenType,
    required String role,
    required int privilegeExpireTime,
  });
}