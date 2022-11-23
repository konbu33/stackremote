import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/authentication/domain/firebase_auth_user.dart';
import 'package:stackremote/channel/channel.dart';

import 'package:stackremote/channel/domain/channel_repository.dart';
import 'package:stackremote/channel/infrastructure/channel_repository_firestore.dart';
import 'package:stackremote/rtc_video/rtc_video.dart';

import '../../user/user_mock.dart';

class MockChannelRepository extends Mock implements ChannelRepository {}

final ChannelRepository channelRepository = MockChannelRepository();

void main() {
  late ProviderContainer container;
  late Future<void> mockResponse;

  setUpAll(() {
    registerFallbackValue(Channel.create());
  });

  setUp(() {
    //
    container = ProviderContainer(overrides: [
      //
      channelRepositoryFirestoreProvider.overrideWithValue(channelRepository),

      //
      rtcChannelStateNotifierProvider
          .overrideWith((ref) => FakeRtcChannelStateNotifier()),

      //
      firebaseAuthUserStateNotifierProvider
          .overrideWith((ref) => FakeFirebaseAuthUserStateNotifier()),
    ]);

    //
    mockResponse = Future.value();
  });
  group('channel_set_usecase', () {
    //

    test(
        'usecase内部で、repositoryの引数として、rtcChannelStateのchannelName、firebaseAuthUser.emailを指定したchannelが指定されていること',
        () async {
      // given

      when(() => channelRepository.set(
            channelName: any(named: "channelName"),
            channel: any(named: "channel"),
          )).thenAnswer((invocation) => mockResponse);

      // when
      final channelSetUsecase = container.read(channelSetUsecaseProvider);
      await channelSetUsecase();

      // then
      final captured = verify(
        () => channelRepository.set(
          channelName: captureAny(
            named: "channelName",
            that: equals(
              FakeRtcChannelState().channelName,
            ),
          ),
          channel: captureAny(
            named: "channel",
          ),
        ),
      ).captured;

      final channelName = captured[0];
      final Channel channel = captured[1];

      expect(channelName, equals(FakeRtcChannelState().channelName));

      expect(channel.hostUserEmail, equals(FakeFirebaseAuthUser().email));
      expect(channel.createAt, equals(null));
    });

    //
  });
}
