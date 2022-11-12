import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../rtc_video/rtc_video.dart';
import '../user/domain/user.dart';

// --------------------------------------------------
//
// FirebaseFirestore Channel Document Reference
//
// --------------------------------------------------
final channelDocumentReferenceProvider = Provider((ref) {
  final channelName = ref.watch(RtcChannelStateNotifierProviderList
      .rtcChannelStateNotifierProvider
      .select((value) => value.channelName));

  final channelDocumentReference =
      FirebaseFirestore.instance.collection('channels').doc(channelName);

  return channelDocumentReference;
});

// --------------------------------------------------
//
// Get users stream
//
// --------------------------------------------------
final userListStreamProvider = StreamProvider((ref) {
  final channelDocumentReference = ref.watch(channelDocumentReferenceProvider);

  final snapshotStream =
      channelDocumentReference.collection('users').snapshots();

  return snapshotStream;
});

// --------------------------------------------------
//
// Get users stream
//
// --------------------------------------------------
final userListProvider = Provider((ref) {
  final userListStream = ref.watch(userListStreamProvider);

  final userList = userListStream.when(
    data: (data) {
      final userList = firestoreQueryToUsers(data);
      return userList;
    },
    error: (error, stackTrace) {
      return [];
    },
    loading: () {
      return [];
    },
  );

  return userList;
});

// --------------------------------------------------
//
// Get UserList from users stream
//
// --------------------------------------------------

final awaitForUserStreamListProvider = Provider((ref) {
  //
  final userList = ref.watch(userListProvider);
  if (userList.isEmpty) return [];

  userList as List<User>;
  final userStreamList = userList.map((user) {
    final userStream = ref.watch(userStreamProviderFamily(user.email));
    return userStream;
  }).toList();

  return userStreamList;
});

// --------------------------------------------------
//
// Get UserStreamList from user list
//
// --------------------------------------------------
// final awaitForUserStreamListProvider =
//     Provider.autoDispose<Iterable<AsyncValue<User>>>((ref) {
//   //
//   final userList = ref.watch(userListProvider);
//   // logger.d("yyyy : awaitForUserStreamListProvider : $userList");

//   final userStreamList = userList.map((user) {
//     final userStream = ref.watch(userStreamProviderFamily(user.email));
//     return userStream;
//   });

//   // logger.d("yyyy : awaitForUserStreamListProvider : $userStreamList");
//   return userStreamList;
// });

/*
  Stream<User> transformQuerySnapshotToUser(
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream,
  ) async* {
    await for (final snapshot in snapshotStream) {
      final docs = snapshot.docs;

      for (final doc in docs) {
        // logger.d("yyy +++++ : ${doc.data()["email"]}");
        final user = firestoreDocToUser(doc);

        // logger.d("yyy +++++ : ${user.email}");
        yield user;
      }
    }
  }

  final userListStream = transformQuerySnapshotToUser(snapshotStream);
  return userListStream;
});

// --------------------------------------------------
//
// Get User Stream from UserList
//
// --------------------------------------------------
final userStreamProvider = Provider<Stream<AsyncValue<User>>>((ref) {
  final channelDocumentReference = ref.watch(channelDocumentReferenceProvider);

  final userListStream = ref.watch(userListStreamProvider.stream);
  logger.d("yyy ----- : $userListStream");

  final userStreamList = userListStream.map((user) {
    //
    final userStream = ref.watch(userStreamProviderFamily(user.email));
    return userStream;
  });

  // Stream<User> transform(Stream<User> userListStream) async* {
  //   await for (final user in userListStream) {
  //     logger.d("yyy ----- : $user");
  //     final snapshotStream = channelDocumentReference
  //         .collection('users')
  //         .doc(user.email)
  //         .snapshots();

  //     await for (final doc in snapshotStream) {
  //       final user = firestoreDocToUser(doc);

  //       yield user;
  //     }
  //   }
  // }

  // final userStream = transform(userListStream);
  // logger.d("yyy ----- : $userStream");
  // return userStream;
  return userStreamList;
});
*/

// --------------------------------------------------
//
// Common Function
//
// --------------------------------------------------
User firestoreDocToUser(DocumentSnapshot<Map<String, dynamic>> doc) {
  if (!doc.exists) throw Exception("ドキュメントが存在しません。");

  final data = doc.data();
  if (data == null) throw Exception("ドキュメント内にデータが存在しません。");

  final user = User.fromJson(data);

  return user;
}

List<User> firestoreQueryToUsers(QuerySnapshot<Map<String, dynamic>> query) {
  final docs = query.docs;

  final userList = docs.map((doc) {
    final data = doc.data();
    final user = User.fromJson(data);
    return user;
  }).toList();

  // final users = Users.create(users: userList);

  // return users;
  return userList;
}

/*
// --------------------------------------------------
//
// Get UserList from Channels
//
// --------------------------------------------------
final userListStreamProvider = StreamProvider<User>((ref) {
  final channelDocumentReference = ref.watch(channelDocumentReferenceProvider);
  final snapshots = channelDocumentReference.collection('users').snapshots();

  Stream<User> transformQueryDocToUser(
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots,
  ) async* {
    await for (final snapshot in snapshots) {
      final docList = snapshot.docs;

      for (final doc in docList) {
        final data = doc.data();
        final user = User.fromJson(data);
        yield user;
      }
    }
  }

  return transformQueryDocToUser(snapshots);
});

// --------------------------------------------------
//
// Get UserDoc Stream from UserList
//
// --------------------------------------------------
final userDocStreamProvider =
    StreamProvider<DocumentSnapshot<Map<String, dynamic>>>((ref) {
  final userListStream = ref.watch(userListStreamProvider.stream);

  final channelDocumentReference = ref.watch(channelDocumentReferenceProvider);

  var streamTransformer = StreamTransformer<User,
          DocumentSnapshot<Map<String, dynamic>>>.fromHandlers(
      handleData: (User user, EventSink sink) {
    final snapshots = channelDocumentReference
        .collection('users')
        .doc(user.email)
        .snapshots();

    snapshots.listen((event) {
      sink.add(event); // ここで変換している
    });
  }, handleError: (Object error, StackTrace stacktrace, EventSink sink) {
    sink.addError("Something happen: $error");
  }, handleDone: (EventSink sink) {
    sink.close();
  });

  final userDocDataStream = userListStream.transform(streamTransformer);
  return userDocDataStream;
});

// --------------------------------------------------
//
// Get User Stream from UserList
//
// --------------------------------------------------
final userStreamProvider = StreamProvider((ref) {
  final userDocStream = ref.watch(userDocStreamProvider.stream);

  var streamTransformer = StreamTransformer<
          DocumentSnapshot<Map<String, dynamic>>, User>.fromHandlers(
      handleData: (DocumentSnapshot<Map<String, dynamic>> doc, EventSink sink) {
    //

    //
    User firestoreDocToUser(DocumentSnapshot<Map<String, dynamic>> doc) {
      if (!doc.exists) throw Exception("ドキュメントが存在しません。");

      final data = doc.data();
      if (data == null) throw Exception("ドキュメント内にデータが存在しません。");

      final user = User.fromJson(data);

      return user;
    }

    final user = firestoreDocToUser(doc);

    sink.add(user); // ここで変換している
  }, handleError: (Object error, StackTrace stacktrace, EventSink sink) {
    sink.addError("Something happen: $error");
  }, handleDone: (EventSink sink) {
    sink.close();
  });

  final userStream = userDocStream.transform(streamTransformer);
  return userStream;
});
*/
