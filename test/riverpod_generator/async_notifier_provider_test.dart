import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_notifier_provider_test.g.dart';

@riverpod
class HelloAsyncNotifier extends _$HelloAsyncNotifier {
  @override
  Future<String> build() {
    return Future.value("Hello AsyncNotifier");
  }

  void add(String s) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => Future.value("${state.value} $s"));
  }
}

@riverpod
class HelloAsyncNotifierF extends _$HelloAsyncNotifierF {
  @override
  Future<String> build({required String init}) {
    return Future.value(init);
  }

  void add(String s) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => Future.value("${state.value} $s"));
  }
}

void main() {
  group("basic", () {
    test("AsyncNotifierProvider build", () async {
      final container = ProviderContainer();

      expect(
          helloAsyncNotifierProvider, isA<AutoDisposeAsyncNotifierProvider>());

      expect(container.read(helloAsyncNotifierProvider), isA<AsyncLoading>());

      // AsyncLoding から AsyncDataになるのを待つ
      await Future<void>.value();

      expect(
          container.read(helloAsyncNotifierProvider), isA<AsyncData<String>>());
      expect(container.read(helloAsyncNotifierProvider).value,
          "Hello AsyncNotifier");
    });
    test("AsyncNotifierProvider add", () async {
      final container = ProviderContainer();

      expect(
          helloAsyncNotifierProvider, isA<AutoDisposeAsyncNotifierProvider>());

      expect(container.read(helloAsyncNotifierProvider), isA<AsyncLoading>());

      await Future<void>.value();

      expect(
          container.read(helloAsyncNotifierProvider), isA<AsyncData<String>>());
      expect(container.read(helloAsyncNotifierProvider).value,
          "Hello AsyncNotifier");

      container.read(helloAsyncNotifierProvider.notifier).add("add");

      expect(container.read(helloAsyncNotifierProvider), isA<AsyncLoading>());

      // AsyncLoding から AsyncDataになるのを待つ
      await Future<void>.value();

      expect(
          container.read(helloAsyncNotifierProvider), isA<AsyncData<String>>());
      expect(container.read(helloAsyncNotifierProvider).value,
          "Hello AsyncNotifier add");
    });
  });

  group("family", () {
    test("AsyncNotifierProvider build", () async {
      final container = ProviderContainer();

      expect(helloAsyncNotifierFProvider, isA<HelloAsyncNotifierFFamily>());

      expect(
          container
              .read(helloAsyncNotifierFProvider(init: "Hello AsyncNotifier")),
          isA<AsyncLoading>());

      // AsyncLoding から AsyncDataになるのを待つ
      await Future<void>.value();

      expect(
          container
              .read(helloAsyncNotifierFProvider(init: "Hello AsyncNotifier")),
          isA<AsyncData<String>>());

      expect(
          container
              .read(helloAsyncNotifierFProvider(init: "Hello AsyncNotifier"))
              .value,
          "Hello AsyncNotifier");
    });

    test("AsyncNotifierProvider add", () async {
      final container = ProviderContainer();

      expect(helloAsyncNotifierFProvider, isA<HelloAsyncNotifierFFamily>());

      expect(
          container
              .read(helloAsyncNotifierFProvider(init: "Hello AsyncNotifier")),
          isA<AsyncLoading>());

      await Future<void>.value();

      expect(
          container
              .read(helloAsyncNotifierFProvider(init: "Hello AsyncNotifier")),
          isA<AsyncData<String>>());

      expect(
          container
              .read(helloAsyncNotifierFProvider(init: "Hello AsyncNotifier"))
              .value,
          "Hello AsyncNotifier");

      container
          .read(
              helloAsyncNotifierFProvider(init: "Hello AsyncNotifier").notifier)
          .add("add");

      expect(
          container
              .read(helloAsyncNotifierFProvider(init: "Hello AsyncNotifier")),
          isA<AsyncLoading>());

      // AsyncLoding から AsyncDataになるのを待つ
      await Future<void>.value();

      expect(
          container
              .read(helloAsyncNotifierFProvider(init: "Hello AsyncNotifier")),
          isA<AsyncData<String>>());
      expect(
          container
              .read(helloAsyncNotifierFProvider(init: "Hello AsyncNotifier"))
              .value,
          "Hello AsyncNotifier add");
    });
  });
}
