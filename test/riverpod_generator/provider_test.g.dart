// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_test.dart';

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

String _$helloHash() => r'1ae856f2b12bc19efd6da64aa72a2b9049ebf4b9';

/// See also [hello].
final helloProvider = AutoDisposeProvider<String Function(String)>(
  hello,
  name: r'helloProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$helloHash,
);
typedef HelloRef = AutoDisposeProviderRef<String Function(String)>;
String _$helloFHash() => r'3dacb11c3b480f0b0b145843e1bb681c2a1e7b16';

/// See also [helloF].
class HelloFProvider extends AutoDisposeProvider<String Function(String)> {
  HelloFProvider({
    required this.init,
  }) : super(
          (ref) => helloF(
            ref,
            init: init,
          ),
          from: helloFProvider,
          name: r'helloFProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$helloFHash,
        );

  final String init;

  @override
  bool operator ==(Object other) {
    return other is HelloFProvider && other.init == init;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, init.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef HelloFRef = AutoDisposeProviderRef<String Function(String)>;

/// See also [helloF].
final helloFProvider = HelloFFamily();

class HelloFFamily extends Family<String Function(String)> {
  HelloFFamily();

  HelloFProvider call({
    required String init,
  }) {
    return HelloFProvider(
      init: init,
    );
  }

  @override
  AutoDisposeProvider<String Function(String)> getProviderOverride(
    covariant HelloFProvider provider,
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
  String? get name => r'helloFProvider';
}
