import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stackremote/channel/channel.dart';
import 'package:stackremote/common/common.dart';

void main() {
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late ProviderContainer container;
  late ChannelRepository channelRepository;

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();

    container = ProviderContainer(overrides: [
      firebaseFirestoreInstanceProvider
          .overrideWithValue(fakeFirebaseFirestore),
    ]);

    channelRepository = container.read(channelRepositoryFirestoreProvider);
  });

  group('ChannelRepositoryFirebase', () {
    //

    test('データ登録可能なこと、且つ、登録したデータを取得可能なこと', () async {
      // given
      const String channelName = "channel1";
      const String hostUserEmail = "xxx@test.com";
      final Channel channel = Channel.create(hostUserEmail: hostUserEmail);

      expect(channel.hostUserEmail, equals(hostUserEmail));
      expect(channel.createAt, equals(null));

      // when
      await channelRepository.set(channelName: channelName, channel: channel);

      final resChannel = await channelRepository.get(channelName: channelName);

      // then
      expect(resChannel.hostUserEmail, equals(hostUserEmail));
      expect(resChannel.createAt, isNot(equals(null)));
      expect(resChannel.createAt, isA<DateTime?>());
    });

    test('データ取得時、コレクションが存在しない場合、エラー発生すること', () async {
      // given
      const String channelName = "channel1";
      const String hostUserEmail = "xxx@test.com";
      final Channel channel = Channel.create(hostUserEmail: hostUserEmail);

      expect(channel.hostUserEmail, equals(hostUserEmail));
      expect(channel.createAt, equals(null));

      // when

      // then
      expect(
        () async => await channelRepository.get(channelName: channelName),
        throwsA(
          allOf(
            isA<StackremoteException>(),
            predicate<StackremoteException>((channelException) {
              expect(channelException.plugin, equals("repository"));
              expect(channelException.code, equals("not_exists"));
              expect(channelException.message, equals("コレクションが存在しません。"));
              return true;

              //
            }),
          ),
        ),
      );
    });

    test('データ取得時、コレクションは存在するが、ドキュメントが存在しない場合、エラー発生すること(※テスト不可そう)', () async {
      // given
      const String channelName = "channel1";
      const String hostUserEmail = "xxx@test.com";
      final Channel channel = Channel.create(hostUserEmail: hostUserEmail);

      expect(channel.hostUserEmail, equals(hostUserEmail));
      expect(channel.createAt, equals(null));

      // when
      await channelRepository.set(channelName: channelName, channel: channel);

      final resChannel = await channelRepository.get(channelName: channelName);

      // then
      expect(resChannel.hostUserEmail, equals(hostUserEmail));
      expect(resChannel.createAt, isNot(equals(null)));
      expect(resChannel.createAt, isA<DateTime?>());

      // ドキュメント削除
      fakeFirebaseFirestore.collection('channels').doc(channelName).delete();

      // コレクションが存在しないエラーが発生するため、ドキュメントをすべて削除すると、コレクションも存在しなくなるように見える。
      // よって、テスト不可そうに思われる。
      expect(
        () async => await channelRepository.get(channelName: channelName),
        throwsA(
          allOf(
            isA<StackremoteException>(),
            predicate<StackremoteException>((channelException) {
              expect(channelException.plugin, equals("repository"));
              expect(channelException.code, equals("not_exists"));
              expect(channelException.message, equals("コレクションが存在しません。"));
              return true;

              //
            }),
          ),
        ),
      );
    });

    //
  });
}
