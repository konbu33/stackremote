import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// --------------------------------------------------
//
// SnackBarWidget
//
// --------------------------------------------------
final snackBarWidgetProvider = Provider((ref) {
  SnackBar buildSnackBarWidget<T>(
    T e,
    Function createMessage,
  ) {
    final snackBarStateProvider = StateProvider((ref) => "");

    // メッセージ生成
    final message = createMessage(e);

    // snackbarにメッセージ設定
    ref.watch(snackBarStateProvider.notifier).update((state) => message);

    // notifierでstate更新した直後に、ref.watch指定すると、
    // '_didChangeDependency == false'エラー発生するため、ref.read指定する。
    // サインアウト後、1回目の認証でパスワード誤った場合に、エラー発生した。

    final SnackBar snackBar = SnackBar(
      content: Text(ref.read(snackBarStateProvider)),
    );

    return snackBar;
  }

  return buildSnackBarWidget;
});
