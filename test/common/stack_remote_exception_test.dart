import 'package:flutter_test/flutter_test.dart';

import 'package:stackremote/common/common.dart';

void main() {
  group('ChannelException', () {
    //

    test('コンストラクタでインスタンス生成した場合、引数指定した値が設定されること、それ以外はデフォルト値が設定されること', () {
      const String plugin = "pluginName";
      const String message = "message";

      const channelException = StackremoteException(
        plugin: plugin,
        message: message,
      );

      expect(channelException.plugin, equals(plugin));
      expect(channelException.code, equals("unknown"));
      expect(channelException.message, equals(message));
      expect(channelException.stackTrace, equals(null));
    });
  });
}
