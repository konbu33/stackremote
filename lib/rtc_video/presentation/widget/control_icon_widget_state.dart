import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'control_icon_widget_state.freezed.dart';

@freezed
class ControlIconWidgetState with _$ControlIconWidgetState {
  //
  const factory ControlIconWidgetState._({
    required bool isX,
    required IconData? enableIcon,
    required IconData? disableIcon,
    required Color? disableColor,
    required String tooltip,
    void Function()? onPressed,
  }) = _ControlIconWidgetState;

  factory ControlIconWidgetState.create({
    bool? isX,
    IconData? enableIcon,
    IconData? disableIcon,
    Color? disableColor,
    String? tooltip,
    void Function()? onPressed,
  }) =>
      ControlIconWidgetState._(
        isX: isX ?? true,
        enableIcon: enableIcon,
        disableIcon: disableIcon,
        disableColor: disableColor,
        tooltip: tooltip ?? "",
        onPressed: onPressed,
      );
}
