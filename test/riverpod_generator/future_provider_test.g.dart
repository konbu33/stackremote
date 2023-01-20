// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'future_provider_test.dart';

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

String _$helloFutureHash() => r'81c4205250a20059e1d69c4b8eb0647a19a86c32';

/// See also [helloFuture].
final helloFutureProvider = AutoDisposeFutureProvider<String>(
  helloFuture,
  name: r'helloFutureProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$helloFutureHash,
);
typedef HelloFutureRef = AutoDisposeFutureProviderRef<String>;
String _$helloFutureFHash() => r'c1f24f3f79ec8b708fd24c49b2e8219149609df6';

/// See also [helloFutureF].
class HelloFutureFProvider extends AutoDisposeFutureProvider<String> {
  HelloFutureFProvider({
    required this.init,
  }) : super(
          (ref) => helloFutureF(
            ref,
            init: init,
          ),
          from: helloFutureFProvider,
          name: r'helloFutureFProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$helloFutureFHash,
        );

  final String init;

  @override
  bool operator ==(Object other) {
    return other is HelloFutureFProvider && other.init == init;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, init.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef HelloFutureFRef = AutoDisposeFutureProviderRef<String>;

/// See also [helloFutureF].
final helloFutureFProvider = HelloFutureFFamily();

class HelloFutureFFamily extends Family<AsyncValue<String>> {
  HelloFutureFFamily();

  HelloFutureFProvider call({
    required String init,
  }) {
    return HelloFutureFProvider(
      init: init,
    );
  }

  @override
  AutoDisposeFutureProvider<String> getProviderOverride(
    covariant HelloFutureFProvider provider,
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
  String? get name => r'helloFutureFProvider';
}
