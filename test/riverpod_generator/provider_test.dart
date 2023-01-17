import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_test.g.dart';

@riverpod
String Function(String s) hello(HelloRef ref) {
  String hello(String s) {
    return "Hello World $s";
  }

  return hello;
}

@riverpod
String Function(String s) helloF(HelloRef ref, {required String init}) {
  String hello(String s) {
    return "$init $s";
  }

  return hello;
}

void main() {
  group("basic", () {
    test("Provider", () {
      final container = ProviderContainer();

      expect(helloProvider, isA<AutoDisposeProvider>());

      final hello = container.read(helloProvider);

      expect(hello("add"), "Hello World add");
    });
  });

  group("family", () {
    test("Provider", () {
      final container = ProviderContainer();

      expect(helloFProvider, isA<HelloFFamily>());

      final hello = container.read(helloFProvider(init: "Hello World"));

      expect(hello("add"), "Hello World add");
    });
  });
}
