import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'control_icon_widget_state.freezed.dart';

@freezed
class ControlIconWidgetState with _$ControlIconWidgetState {
  //
  const factory ControlIconWidgetState._({
    required bool isMute,
    required IconData? enableIcon,
    required IconData? disableIcon,
    required Color? disableColor,
    void Function()? onPressed,
  }) = _ControlIconWidgetState;

  factory ControlIconWidgetState.create({
    bool? isMute,
    IconData? enableIcon,
    IconData? disableIcon,
    Color? disableColor,
    void Function()? onPressed,
  }) =>
      ControlIconWidgetState._(
        isMute: isMute ?? true,
        enableIcon: enableIcon,
        disableIcon: disableIcon,
        disableColor: disableColor,
        onPressed: onPressed,
      );
}
