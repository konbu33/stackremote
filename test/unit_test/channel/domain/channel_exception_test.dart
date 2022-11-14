import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/channel/domain/channel_exception.dart';

void main() {
  group('ChannelException', () {
    //

    test('コンストラクタでインスタンス生成した場合、引数指定した値が設定されること、それ以外はデフォルト値が設定されること', () {
      const String plugin = "pluginName";
      const channelException = ChannelException(plugin: plugin);

      expect(channelException.plugin, equals(plugin));
      expect(channelException.code, equals("unknown"));
      expect(channelException.message, equals(null));
      expect(channelException.stackTrace, equals(null));
    });
  });
}
