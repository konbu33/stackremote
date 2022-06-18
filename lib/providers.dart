import 'package:hooks_riverpod/hooks_riverpod.dart';

class Providers {
  const Providers();

  static final helloWorldProvider =
      StateProvider<String>((ref) => "Hello World Riverpod.");

  static final testProvider = Provider((ref) => ref.read(helloWorldProvider));
}
