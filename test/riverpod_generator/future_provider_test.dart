import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'future_provider_test.g.dart';

@riverpod
Future<String> helloFuture(HelloFutureRef ref) {
  return Future.value("Hello Future");
}

@riverpod
Future<String> helloFutureF(HelloFutureFRef ref, {required String init}) {
  return Future.value("Hello Future");
}

void main() {
  group("basic", () {
    test("FutureProvider", () async {
      final container = ProviderContainer();

      expect(helloFutureProvider, isA<AutoDisposeFutureProvider>());
      expect(container.read(helloFutureProvider), isA<AsyncLoading>());

      // AsyncLoding から AsyncDataになるのを待つ
      await Future<void>.value();

      expect(
        container.read(helloFutureProvider),
        isA<AsyncData<String>>().having((s) => s.value, "", "Hello Future"),
      );

      expect(container.read(helloFutureProvider).value, "Hello Future");
    });
  });

  group("family", () {
    test("FutureProvider", () async {
      final container = ProviderContainer();

      expect(helloFutureFProvider, isA<HelloFutureFFamily>());
      expect(container.read(helloFutureFProvider(init: "Hello Future")),
          isA<AsyncLoading>());

      // AsyncLoding から AsyncDataになるのを待つ
      await Future<void>.value();

      expect(
        container.read(helloFutureFProvider(init: "Hello Future")),
        isA<AsyncData<String>>().having((s) => s.value, "", "Hello Future"),
      );

      expect(container.read(helloFutureFProvider(init: "Hello Future")).value,
          "Hello Future");
    });
  });
}
