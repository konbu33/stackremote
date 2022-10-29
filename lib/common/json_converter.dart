import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// --------------------------------------------------
//
//  OffsetConverter
//
// --------------------------------------------------
class OffsetConverter extends JsonConverter<Offset, String> {
  const OffsetConverter();

  @override
  String toJson(Offset object) {
    final double dx = object.dx;
    final double dy = object.dy;
    final Map<String, double> jsonMap = {
      "dx": dx,
      "dy": dy,
    };
    return jsonEncode(jsonMap);
  }

  @override
  Offset fromJson(String json) {
    // logger.d("Offset json : $json");
    final Map<String, dynamic> jsonMap = jsonDecode(json);
    final double dx = jsonMap["dx"];
    final double dy = jsonMap["dy"];

    return Offset(dx, dy);
  }
}

// --------------------------------------------------
//
//  TextEditingControllerConverter
//
// --------------------------------------------------
class TextEditingControllerConverter
    extends JsonConverter<TextEditingController, String> {
  const TextEditingControllerConverter();

  @override
  String toJson(TextEditingController object) {
    return object.text;
  }

  @override
  TextEditingController fromJson(String json) {
    return TextEditingController(text: json);
  }
}

// // --------------------------------------------------
// //
// //  TimestampConverter
// //
// // --------------------------------------------------
// class TimestampConverter extends JsonConverter<Timestamp, String> {
//   const TimestampConverter();

//   @override
//   String toJson(Timestamp object) {
//     return object.toString();
//   }

//   @override
//   Timestamp fromJson(String json) {
//     var parsedDate = DateTime.parse(json);
//     return Timestamp.fromDate(parsedDate);
//   }
// }

// --------------------------------------------------
//
//  FirestoreTimestampConverter
//
// --------------------------------------------------
class FirestoreTimestampConverter extends JsonConverter<Timestamp?, dynamic> {
  const FirestoreTimestampConverter();

  @override
  String? toJson(Timestamp? object) {
    if (object == null) return null;
    return object.toString();
  }

  @override
  Timestamp? fromJson(dynamic json) {
    if (json is Timestamp) return json;
    return null;
  }

//   @override
//   Timestamp? fromJson(dynamic json) {
//     // logger.d("fromJson: $json");
//     if (json is Timestamp) {
//       DateTime createdAt = json.toDate();
//       Timestamp createdAtTimestamp = Timestamp.fromDate(createdAt);
//       // logger.d("createdAtTimestamp : $createdAtTimestamp");
//       return createdAtTimestamp;
//     }

//     return null;
//   }
}

// --------------------------------------------------
//
//  CreatedAtTimestampConverter
//
// --------------------------------------------------
class CreatedAtTimestampConverter extends JsonConverter<Timestamp?, dynamic> {
  const CreatedAtTimestampConverter();

  @override
  dynamic toJson(Timestamp? object) {
    if (object == null) return FieldValue.serverTimestamp();
    return object;
  }

  @override
  Timestamp? fromJson(dynamic json) {
    if (json is Timestamp) return json;
    return null;
  }
}
