import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../user/user.dart';

class DisplaySizeVideoState {
  // 自身のデバイスの表示サイズを保持
  static final displaySizeVideoMainProvider =
      StateProvider.autoDispose((ref) => const Size(0, 0));

  // 各参加者のデバイスの表示サイズを比較し、最小の表示サイズを算出し、保持する。
  // メインビデオの表示サイズを共通の表示サイズに合わせておかないと、ポインタの表示を共有しても、ポインタの表示位置がずれるため、
  // メインビデオの表示サイズを最小の表示サイズに合わせるために、利用する。
  static final displaySizeVideoMainMinProvider =
      StateProvider.autoDispose((ref) {
    //
    Size getMinSize() {
      final usersState = ref.watch(usersStateNotifierProvider);

      final joinedUserList = usersState.users.where((user) {
        // join中のユーザリスト作成
        return user.leavedAt == null;
      }).toList();

      if (joinedUserList.isEmpty) {
        final displaySizeVideoMain =
            ref.watch(DisplaySizeVideoState.displaySizeVideoMainProvider);

        return displaySizeVideoMain;
      }

      final widthList = joinedUserList.map((user) {
        return user.displaySizeVideoMain.width;
      }).toList();

      final minWidth = widthList.reduce(min);

      final heightList = joinedUserList.map((user) {
        return user.displaySizeVideoMain.height;
      }).toList();

      final minHeight = heightList.reduce(min);

      return Size(minWidth, minHeight);
    }

    final minSize = getMinSize();

    return minSize;
  });
}
