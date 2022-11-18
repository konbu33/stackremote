import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'description_message_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class DescriptionMessageState with _$DescriptionMessageState {
  const factory DescriptionMessageState._({
    required String message,
  }) = _DescriptionMessageState;

  factory DescriptionMessageState.create({
    String? message,
  }) =>
      DescriptionMessageState._(
        message: message ?? "",
      );
}

// --------------------------------------------------
//
//   StateNotifier
//
// --------------------------------------------------
class DescriptionMessageStateNotifier
    extends StateNotifier<DescriptionMessageState> {
  DescriptionMessageStateNotifier({
    String? message,
  }) : super(DescriptionMessageState.create(message: message));

  void setMessage(String message) {
    state = state.copyWith(message: message);
  }
}

// --------------------------------------------------
//
//   Type DescriptionMessageStateProvider
//
// --------------------------------------------------
typedef DescriptionMessageStateProvider = AutoDisposeStateNotifierProvider<
    DescriptionMessageStateNotifier, DescriptionMessageState>;

// --------------------------------------------------
//
//   DescriptionMessageStateProviderCreator
//
// --------------------------------------------------
DescriptionMessageStateProvider descriptionMessageStateProviderCreator({
  String? message,
}) {
  return StateNotifierProvider.autoDispose<DescriptionMessageStateNotifier,
      DescriptionMessageState>((ref) {
    return DescriptionMessageStateNotifier(message: message);
  });
}
