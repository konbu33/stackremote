import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'description_widget_state.freezed.dart';

@freezed
class DescriptionWidgetState with _$DescriptionWidgetState {
  const factory DescriptionWidgetState._({
    required String imagePath,
    required String title,
    required String description,
  }) = _DescriptionWidgetState;

  factory DescriptionWidgetState.create({
    required String imagePath,
    required String title,
    required String description,
  }) =>
      DescriptionWidgetState._(
        imagePath: imagePath,
        title: title,
        description: description,
      );
}
