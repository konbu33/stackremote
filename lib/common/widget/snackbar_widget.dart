import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'snackbar_widget.freezed.dart';

// --------------------------------------------------
//
// SnackBarWidget
//
// --------------------------------------------------
class SnackBarWidget extends HookConsumerWidget {
  const SnackBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snackBarState = ref.watch(snackBarStateProvider);

    final SnackBar snackBar = SnackBar(
      content: Text(snackBarState.message),
    );

    return snackBar;
  }
}

// --------------------------------------------------
//
// SnackBarState
//
// --------------------------------------------------
@freezed
class SnackBarState with _$SnackBarState {
  const factory SnackBarState._({
    required String message,
  }) = _SnackBarState;

  factory SnackBarState.create({
    required String message,
  }) =>
      SnackBarState._(
        message: message,
      );
}

class SnackBarStateNotifier extends StateNotifier<SnackBarState> {
  SnackBarStateNotifier({
    String? message,
  }) : super(SnackBarState.create(
          message: message ?? "",
        ));

  void setMessage(String message) {
    state = state.copyWith(message: message);
  }
}

typedef SnackBarStateProvider
    = StateNotifierProvider<SnackBarStateNotifier, SnackBarState>;

SnackBarStateProvider snackBarStateNotifierProviderCreator({
  String? message,
}) {
  final snackBarStateProvider =
      StateNotifierProvider<SnackBarStateNotifier, SnackBarState>(
          (ref) => SnackBarStateNotifier(
                message: message ?? "",
              ));

  return snackBarStateProvider;
}

final snackBarStateProvider = snackBarStateNotifierProviderCreator();
