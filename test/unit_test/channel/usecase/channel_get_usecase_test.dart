import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:stackremote/channel/domain/channel.dart';
import 'package:stackremote/channel/domain/channel_repository.dart';
import 'package:stackremote/channel/infrastructure/channel_repository_firestore.dart';
import 'package:stackremote/channel/usecace/channel_get_usecase.dart';
import 'package:stackremote/common/common.dart';

import '../../user/user_mock.dart';

class MockChannelRepository extends Mock implements ChannelRepository {}

final ChannelRepository channelRepository = MockChannelRepository();

void main() {
  late ProviderContainer container;
  late Future<Channel> mockResponse;
  late String hostUserEmail;

  setUp(() {
    //
    container = ProviderContainer(overrides: [
      //
      channelRepositoryFirestoreProvider.overrideWithValue(channelRepository),

      //
      channelNameProvider
          .overrideWith((ref) => ref.watch(fakeChannelNameProvider)),
      // .overrideWith((ref) => FakeRtcChannelStateNotifier()),
    ]);

    //
    hostUserEmail = "xxx@test.com";
    final channel = Channel.create(hostUserEmail: hostUserEmail);
    mockResponse = Future.value(channel);
  });
  group('channel_get_usecase', () {
    //

    test('usecase内部で、repositoryの引数として、rtcChannelStateのchannelNameが指定されていること',
        () async {
      // given

      when(() => channelRepository.get(channelName: any(named: "channelName")))
          .thenAnswer((invocation) => mockResponse);

      // when
      final fakeChannelName = container.read(channelNameProvider);
      final channelGetUsecase = container.read(channelGetUsecaseProvider);
      final resChannel = await channelGetUsecase();

      // then
      final captured = verify(
        () => channelRepository.get(
          channelName: captureAny(
            named: "channelName",
            that: equals(
              fakeChannelName,
            ),
          ),
        ),
      ).captured;

      final channelName = captured[0];

      expect(channelName, fakeChannelName);

      logger.d("$channelName, $resChannel");
      expect(resChannel.hostUserEmail, equals(hostUserEmail));
      expect(resChannel.createAt, equals(null));
    });

    //
  });
}
