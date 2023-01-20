// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier_provider_test.dart';

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

String _$HelloNotifierHash() => r'f8ce33ed3810a68707bde2dca0aac0cd34709d3e';

/// See also [HelloNotifier].
final helloNotifierProvider =
    AutoDisposeNotifierProvider<HelloNotifier, String>(
  HelloNotifier.new,
  name: r'helloNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$HelloNotifierHash,
);
typedef HelloNotifierRef = AutoDisposeNotifierProviderRef<String>;

abstract class _$HelloNotifier extends AutoDisposeNotifier<String> {
  @override
  String build();
}

String _$HelloNotifierFHash() => r'79481704ae68d7649b679e7674663c12f2312a66';

/// See also [HelloNotifierF].
class HelloNotifierFProvider
    extends AutoDisposeNotifierProviderImpl<HelloNotifierF, String> {
  HelloNotifierFProvider({
    required this.init,
  }) : super(
          () => HelloNotifierF()..init = init,
          from: helloNotifierFProvider,
          name: r'helloNotifierFProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$HelloNotifierFHash,
        );

  final String init;

  @override
  bool operator ==(Object other) {
    return other is HelloNotifierFProvider && other.init == init;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, init.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String runNotifierBuild(
    covariant _$HelloNotifierF notifier,
  ) {
    return notifier.build(
      init: init,
    );
  }
}

typedef HelloNotifierFRef = AutoDisposeNotifierProviderRef<String>;

/// See also [HelloNotifierF].
final helloNotifierFProvider = HelloNotifierFFamily();

class HelloNotifierFFamily extends Family<String> {
  HelloNotifierFFamily();

  HelloNotifierFProvider call({
    required String init,
  }) {
    return HelloNotifierFProvider(
      init: init,
    );
  }

  @override
  AutoDisposeNotifierProviderImpl<HelloNotifierF, String> getProviderOverride(
    covariant HelloNotifierFProvider provider,
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
  String? get name => r'helloNotifierFProvider';
}

abstract class _$HelloNotifierF extends BuildlessAutoDisposeNotifier<String> {
  late final String init;

  String build({
    required String init,
  });
}
