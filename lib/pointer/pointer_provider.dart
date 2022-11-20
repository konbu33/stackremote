import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:stackremote/pointer/pointer_overlay_state.dart';

// import '../common/common.dart';
import '../common/common.dart';
import '../user/domain/user.dart';
import '../user/domain/users.dart';
import '../user/usecace/user_fetch_all_usecase.dart';
import '../user/usecace/user_fetch_by_id_usecase.dart';
import 'pointer_state.dart';

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
  // final usersStream = ref.watch(usersStreamProvider);

  final usersList = ref.watch(usersStateNotifierProvider);
  logger.d("yyy2 : ${usersList.users}");

  // final userStreamList = usersStream.when(data: (users) {
  //   final userList = users.users;

  //   if (userList.isEmpty) return [];

  //   final userStreamList = userList.map((user) {
  //     final userStream = ref.watch(userStreamProviderFamily(user.email));
  //     return userStream;
  //   }).toList();

  //   //
  //   return userStreamList;
  // }, error: (error, stackTrace) {
  //   //
  //   return [];
  // }, loading: () {
  //   //
  //   return [];
  // });

  final userStreamList = usersList.users.map((user) {
    final userStream = ref.watch(userStreamProviderFamily(user.email));
    return userStream;
  }).toList();

  // logger.d(" yyy : $userStreamList");

  return userStreamList;
});

// --------------------------------------------------
//
// Get PointerState from userStreamList
//
// --------------------------------------------------

final pointerStateProvider = Provider((ref) {
  final userStreamList = ref.watch(pointerProvider);

  // logger.d(" yyyx : $userStreamList");

  if (userStreamList.isEmpty) return [];

  userStreamList as List<AsyncValue<User>>;

  final List<PointerState?> pointerStateListNullable =
      userStreamList.map((userStream) {
    final pointerState = userStream.when(data: (user) {
      PointerState userToPointerState(User user) {
        final pointerState = PointerState.reconstruct(
          comment: user.comment,
          email: user.email,
          isOnLongPressing: user.isOnLongPressing,
          nickName: user.nickName,
          pointerPosition: user.pointerPosition,
        );

        return pointerState;
      }

      final pointerState = (userToPointerState(user));

      return pointerState;
    }, error: (error, stackTrace) {
      //
      return null;
    }, loading: () {
      //
      return null;
    });

    return pointerState;
  }).toList();

  final pointerStateList =
      pointerStateListNullable.whereType<PointerState>().toList();

  if (pointerStateList.isNotEmpty) {
    // final pointerOverlayStateNotifier =
    //     ref.watch(pointerOverlayStateNotifierProvider.notifier);
    // logger.d(" yyyx : $pointerStateList");

    // pointerOverlayStateNotifier.setPointerStateList(pointerStateList);
    // logger.d(" yyyy : $pointerStateList");
  }
  // logger.d(" yyyz : $pointerStateList");

  return pointerStateList;
});
