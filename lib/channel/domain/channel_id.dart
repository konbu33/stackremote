import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:ulid/ulid.dart';

part 'channel_id.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class ChannelId with _$ChannelId {
  /* 
    生成的コンストラクタでのインスタンス生成を不可とし、
    プライベートコンストラタでのみインスタンス生成可能とするように制限する。
  */
  const factory ChannelId._({
    required Ulid value,
  }) = _ChannelId;

  /*
    生成的コンストラクタを利用したインスタンス生成は不可にし、
    ファクトリメソッドからプライベートコンストラクタを利用したインスタンス生成可能に制限する。
  */
  factory ChannelId.create() => ChannelId._(value: Ulid());
}

// --------------------------------------------------
//
//  JsonConverter
//
// --------------------------------------------------

// fromJson, toJsonメソッド利用可能にするためのコンバータ
class ChannelIdConverter extends JsonConverter<ChannelId, String> {
  const ChannelIdConverter();

  @override
  ChannelId fromJson(String json) {
    return ChannelId._(value: Ulid.parse(json));
  }

  @override
  String toJson(ChannelId object) {
    return object.value.toString();
  }
}
