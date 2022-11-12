import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../user/domain/user.dart';
import '../user/domain/users.dart';
import '../user/usecace/user_fetch_all_usecase.dart';
import '../user/usecace/user_fetch_by_id_usecase.dart';

// --------------------------------------------------
//
// usersStreamProvider
//
// --------------------------------------------------

final usersStreamProvider = StreamProvider<Users>((ref) {
  final userFetchAllUsecase = ref.watch(userFetchAllUsecaseProvider);
  final usersStream = userFetchAllUsecase();
  return usersStream;
});

// --------------------------------------------------
//
// userStreamProvider
//
// --------------------------------------------------

final userStreamProviderFamily =
    StreamProvider.family<User, String>((ref, email) {
  final userFetchByIdUsecase = ref.watch(userFetchByIdUsecaseProvider);
  final userStream = userFetchByIdUsecase(email: email);
  return userStream;
});

// --------------------------------------------------
//
// Get UserList from users stream
//
// --------------------------------------------------

final pointerProvider = Provider((ref) {
  final usersStream = ref.watch(usersStreamProvider);

  final userStreamList = usersStream.when(data: (users) {
    final userList = users.users;

    if (userList.isEmpty) return [];

    final userStreamList = userList.map((user) {
      final userStream = ref.watch(userStreamProviderFamily(user.email));
      return userStream;
    }).toList();

    //
    return userStreamList;
  }, error: (error, stackTrace) {
    //
    return [];
  }, loading: () {
    //
    return [];
  });

  return userStreamList;
});
