import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/user.dart';

import '../page/user_detail_page.dart';
import '../page/user_detail_page_state.dart';
import '../page/user_page_state.dart';

class UserListWidget extends StatelessWidget {
  const UserListWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  final UserPageState state;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // 全ユーザ情報取得
        final usersStream = ref.watch(state.usersStreamProvider);
        return usersStream.when(
          // ローディング時
          loading: () => const CircularProgressIndicator(),

          // エラー時
          error: (error, stacktrace) => const Text("error"),

          // データ取得成功時
          data: (data) {
            return Flexible(
              // 全ユーザの一覧生成
              child: ListView.builder(
                itemCount: data.users.length,
                itemBuilder: (context, index) {
                  final user = data.users[index];
                  final email = user.email;
                  final userId = user.userId.value.toString();

                  // 各ユーザ毎の情報生成
                  return ListTile(
                    title: Text(email),
                    subtitle: Text(userId),

                    // タップされたユーザ情報を削除
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        state.userDeleteUseCase.execute(userId);
                      },
                    ),

                    // タップされたユーザ情情を更新
                    onTap: () async {
                      // タップされたユーザ情情を取得
                      final User user =
                          await state.userFindByIdUseCase.execute(userId);

                      // UserDetailPageStateのメソッド利利したいため
                      final notifier = ref
                          .read(userDetailPageStateControllerProvider.notifier);

                      // タップされたユーザ情情を初期値として設定
                      notifier.setUserEmailAndPassword(user);

                      //ModalBottomSheet処理内でのonSubmit処理を最終確定
                      notifier.setUserUpdateOnSubmit();

                      // ModalBottomSheetでの処理
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const UserDetailPage();
                        },
                      );

                      // 初期化処理
                      notifier.clearUserEmailAndPassword();
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
