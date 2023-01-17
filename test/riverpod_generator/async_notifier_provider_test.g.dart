// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_notifier_provider_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

String _$HelloAsyncNotifierHash() =>
    r'964ee5fbd75f8bda8b8c7324c5d7e3f5d87d76fa';

/// See also [HelloAsyncNotifier].
final helloAsyncNotifierProvider =
    AutoDisposeAsyncNotifierProvider<HelloAsyncNotifier, String>(
  HelloAsyncNotifier.new,
  name: r'helloAsyncNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$HelloAsyncNotifierHash,
);
typedef HelloAsyncNotifierRef = AutoDisposeAsyncNotifierProviderRef<String>;

abstract class _$HelloAsyncNotifier extends AutoDisposeAsyncNotifier<String> {
  @override
  FutureOr<String> build();
}

String _$HelloAsyncNotifierFHash() =>
    r'252066664a9c59715d5fbc0311f176e8122f017c';

/// See also [HelloAsyncNotifierF].
class HelloAsyncNotifierFProvider
    extends AutoDisposeAsyncNotifierProviderImpl<HelloAsyncNotifierF, String> {
  HelloAsyncNotifierFProvider({
    required this.init,
  }) : super(
          () => HelloAsyncNotifierF()..init = init,
          from: helloAsyncNotifierFProvider,
          name: r'helloAsyncNotifierFProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$HelloAsyncNotifierFHash,
        );

  final String init;

  @override
  bool operator ==(Object other) {
    return other is HelloAsyncNotifierFProvider && other.init == init;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, init.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<String> runNotifierBuild(
    covariant _$HelloAsyncNotifierF notifier,
  ) {
    return notifier.build(
      init: init,
    );
  }
}

typedef HelloAsyncNotifierFRef = AutoDisposeAsyncNotifierProviderRef<String>;

/// See also [HelloAsyncNotifierF].
final helloAsyncNotifierFProvider = HelloAsyncNotifierFFamily();

class HelloAsyncNotifierFFamily extends Family<AsyncValue<String>> {
  HelloAsyncNotifierFFamily();

  HelloAsyncNotifierFProvider call({
    required String init,
  }) {
    return HelloAsyncNotifierFProvider(
      init: init,
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderImpl<HelloAsyncNotifierF, String>
      getProviderOverride(
    covariant HelloAsyncNotifierFProvider provider,
  ) {
    return call(
      init: provider.init,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'helloAsyncNotifierFProvider';
}

abstract class _$HelloAsyncNotifierF
    extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final String init;

  FutureOr<String> build({
    required String init,
  });
}
