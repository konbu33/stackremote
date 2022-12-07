import 'package:hooks_riverpod/hooks_riverpod.dart';

// --------------------------------------------------
//
//   ProgressStateNotifier
//
// --------------------------------------------------
class ProgressStateNotifier extends AutoDisposeAsyncNotifier<void> {
  ProgressStateNotifier({
    required this.function,
  });
  @override
  void build() {
    // voidの場合、初期化不要。
  }

  final ProgressFunction function;

  void updateProgress() async {
    // まずローディング中であることを保持する。
    state = const AsyncLoading();

    // 結果を受けて、Data or Errorを保持する。
    state = await AsyncValue.guard(function);
  }
}

// --------------------------------------------------
//
//   progressStateNotifierProviderCreator
//
// --------------------------------------------------
typedef ProgressStateNotifierProvider
    = AutoDisposeAsyncNotifierProvider<ProgressStateNotifier, void>;

typedef ProgressFunction = Future<void> Function();

ProgressStateNotifierProvider progressStateNotifierProviderCreator({
  required ProgressFunction function,
}) {
  return AutoDisposeAsyncNotifierProvider<ProgressStateNotifier, void>(() {
    return ProgressStateNotifier(function: function);
  });
}
