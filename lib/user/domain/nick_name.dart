import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../../authentication/authentication.dart';

class NickName {
  static final nickNameCreatorProvider = Provider((ref) {
    //
    String nickNameCreator(String newNickName) {
      String nickName = newNickName;

      const lengthLimit = 8;
      if (nickName.length > lengthLimit) {
        nickName = nickName.substring(0, lengthLimit);
        nickName += "...";
      }

      return nickName;
    }

    return nickNameCreator;
  });

  static final nickNameProvider = StateProvider((ref) {
    //

    final getStringUsecase = ref.watch(getStringUsecaseProvider);
    final nickNameFromLocalStrage = getStringUsecase(key: "nickName");
    if (nickNameFromLocalStrage != null) return nickNameFromLocalStrage;

    final email = ref.watch(
        firebaseAuthUserStateNotifierProvider.select((value) => value.email));

    final nickNameCreator = ref.watch(nickNameCreatorProvider);

    return nickNameCreator(email.split("@")[0]);
  });
}
