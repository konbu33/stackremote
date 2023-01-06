import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseFirestoreInstanceProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

typedef JsonMap = Map<String, dynamic>;
