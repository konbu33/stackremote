import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/common.dart';
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

// // --------------------------------------------------
// //
// // Get UserList from Channels
// //
// // --------------------------------------------------
// final userListStreamProvider = StreamProvider((ref) {
//   final channelDocumentReference = ref.watch(channelDocumentReferenceProvider);
//   final snapshots = channelDocumentReference.collection('users').snapshots();

//   return snapshots;
// });

// // --------------------------------------------------
// //
// // Get User Stream from UserList
// //
// // --------------------------------------------------
// final userStreamProvider = StreamProvider((ref) {
//   final channelDocumentReference = ref.watch(channelDocumentReferenceProvider);

//   final userListStream = ref.watch(userListStreamProvider.stream);
//   logger.d("------------------ xxxx : ");

//   Stream<Stream<DocumentSnapshot<Map<String, dynamic>>>> a(
//       dynamic stream) async* {
//     await for (final event in stream) {
//       final docs = event.docs;
//       final doc = docs.first.data();
//       final email = doc["email"];

//       final snapshots =
//           channelDocumentReference.collection('users').doc(email).snapshots();

//       yield snapshots;
//     }
//   }

//   return a(userListStream);

//   // return ref.watch(userListStreamProvider.stream).map((event) {
//   //   final docs = event.docs;
//   //   final doc = docs.first.data();
//   //   final email = doc["email"];

//   //   final snapshots =
//   //       channelDocumentReference.collection('users').doc(email).snapshots();

//   //   return snapshots;
//   // });
// });

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
