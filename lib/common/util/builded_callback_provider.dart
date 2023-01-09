import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// --------------------------------------------------
//
// 「build完了後に実行しないと実行エラーになる関数」を実行するための関数
// より具体的には、StatelessWidgetのbuild後に、
// 「riverpodのnotifier系のメソッドで状態更新するための関数」を実行するための関数
//
// --------------------------------------------------
final buildedCallbackProvider = Provider((ref) {
  void buildedCallback<T>({
    required Function(T? data) callback,
    T? data,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback(data);
    });
  }

  return buildedCallback;
});
