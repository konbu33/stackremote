import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:ulid/ulid.dart';

part 'userid.freezed.dart';

@freezed
class UserId with _$UserId {
  /* 
    生成的コンストラクタでのインスタンス生成を不可とし、
    プライベートコンストラタでのみインスタンス生成可能とするように制限する。
  */
  const factory UserId._({
    required String value,
  }) = _UserId;

  /*
    生成的コンストラクタを利用したインスタンス生成は不可にし、
    ファクトリメソッドからプライベートコンストラクタを利用したインスタンス生成可能に制限する。
  */
  factory UserId.create({
    String? value,
  }) =>
      UserId._(
        value: value ?? Ulid().toString(),
      );
}

// fromJson, toJsonメソッド利用可能にするためのコンバータ
class UserIdConverter extends JsonConverter<UserId, String> {
  const UserIdConverter();

  @override
  UserId fromJson(String json) {
    return UserId._(value: json);
  }

  @override
  String toJson(UserId object) {
    return object.value.toString();
  }
}
