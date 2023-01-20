import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier_provider_test.g.dart';

@riverpod
class HelloNotifier extends _$HelloNotifier {
  @override
  String build() {
    return "Hello World";
  }

  void add(String s) {
    state = "$state $s";
  }
}

@riverpod
class HelloNotifierF extends _$HelloNotifierF {
  @override
  String build({required String init}) {
    return init;
  }

  void add(String s) {
    state = "$state $s";
  }
}

void main() {
  group("basic", () {
    test("NotifierProvider build", () {
      final container = ProviderContainer();

      expect(helloNotifierProvider, isA<AutoDisposeNotifierProvider>());
      expect(container.read(helloNotifierProvider), "Hello World");
    });

    test("NotifierProvider add", () {
      final container = ProviderContainer();

      expect(helloNotifierProvider, isA<AutoDisposeNotifierProvider>());
      expect(container.read(helloNotifierProvider), "Hello World");

      container.read(helloNotifierProvider.notifier).add("add");
      expect(container.read(helloNotifierProvider), "Hello World add");
    });
  });

  group("family", () {
    test("NotifierProvider build", () {
      final container = ProviderContainer();

      expect(helloNotifierFProvider, isA<HelloNotifierFFamily>());
      expect(container.read(helloNotifierFProvider(init: "Hello World")),
          "Hello World");
    });

    test("NotifierProvider add", () {
      final container = ProviderContainer();

      expect(helloNotifierFProvider, isA<HelloNotifierFFamily>());
      expect(container.read(helloNotifierFProvider(init: "Hello World")),
          "Hello World");

      container
          .read(helloNotifierFProvider(init: "Hello World").notifier)
          .add("add");

      expect(container.read(helloNotifierFProvider(init: "Hello World")),
          "Hello World add");
    });
  });
}
