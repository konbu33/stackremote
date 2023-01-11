import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'min_max.freezed.dart';

@freezed
class MinMax<T> with _$MinMax<T> {
  const factory MinMax._({
    required T min,
    required T max,
  }) = _MinMax<T>;

  factory MinMax.create({
    required T min,
    required T max,
  }) {
    return MinMax<T>._(
      min: min,
      max: max,
    );
  }
}
