import 'package:flutter_test/flutter_test.dart';

import 'package:stackremote/channel/channel.dart';

void main() {
  group('Channel', () {
    //

    test('createファクトリメソッドで引数指定せずにインスタンス生成した場合、デフォルト値が設定されること', () {
      // given

      // when
      final channel = Channel.create();

      // then
      expect(channel.hostUserEmail, equals(""));
      expect(channel.createAt, equals(null));
    });

    test('createファクトリメソッドで引数指定してインスタンス生成した場合、引数の値が設定されること。それ以外はデフォルト値が設定されること',
        () {
      // given

      // when
      const String hostUserEmail = "xxx@test.com";
      final createAt = DateTime.now();
      final channel = Channel.create(
        hostUserEmail: hostUserEmail,
        createAt: createAt,
      );

      // then
      expect(channel.hostUserEmail, equals(hostUserEmail));
      expect(channel.createAt, equals(createAt));
    });

    test('生成的コンストラクタ、プライベートコンストラクタでインスタンス不可なこと', () {
      // given

      // when
      // final channel1 = Channel();
      // final channel2 = Channel._();

      // then
    });

    test('toJsonとfromJsonで相互変換可能なこと', () {
      // given
      const String hostUserEmail = "xxx@test.com";
      final createAt = DateTime.now();
      final channel = Channel.create(
        hostUserEmail: hostUserEmail,
        createAt: createAt,
      );

      expect(channel.hostUserEmail, equals(hostUserEmail));
      expect(channel.createAt, equals(createAt));

      // when
      final channelToJson = channel.toJson();
      expect(channelToJson["hostUserEmail"], equals(hostUserEmail));
      // expect(channelToJson["createAt"], isA<FieldValue>());
      expect(channelToJson["createAt"], equals(createAt.toString()));

      // then
      final channelFromJson = Channel.fromJson(channelToJson);
      // logger.d("$channelToJson \n\n $channelFromJson");
      expect(channelFromJson.hostUserEmail, equals(hostUserEmail));
      expect(channelFromJson.createAt, equals(createAt));
    });

    test('toJsonとfromJsonで相互変換可能なこと。createAtがNullのパターン', () {
      // given
      const String hostUserEmail = "xxx@test.com";
      const DateTime? createAt = null;
      final channel = Channel.create(
        hostUserEmail: hostUserEmail,
        createAt: createAt,
      );

      expect(channel.hostUserEmail, equals(hostUserEmail));
      expect(channel.createAt, equals(createAt));

      // when
      final channelToJson = channel.toJson();
      expect(channelToJson["hostUserEmail"], equals(hostUserEmail));
      expect(channelToJson["createAt"], isA<DateTime?>());
      // expect(channelToJson["createAt"], equals(createAt));

      // then
      final channelFromJson = Channel.fromJson(channelToJson);
      // logger.d("$channelToJson \n\n $channelFromJson");
      expect(channelFromJson.hostUserEmail, equals(hostUserEmail));
      expect(channelFromJson.createAt, equals(createAt));
    });

    //
  });
}
