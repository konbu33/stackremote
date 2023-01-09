import 'dart:convert';

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
// //  FirestoreTimestampConverter
// //
// // --------------------------------------------------
// class FirestoreTimestampConverter extends JsonConverter<Timestamp?, dynamic> {
//   const FirestoreTimestampConverter();

//   @override
//   String? toJson(Timestamp? object) {
//     if (object == null) return null;
//     // return object.toString();

//     // Timestampのままだと、String <-> Timestampの変換がうまくできないため、
//     // TimestampをDateTimeのStringとして保持する。
//     return object.toDate().toString();
//   }

//   @override
//   Timestamp? fromJson(dynamic json) {
//     if (json is Timestamp) return json;

//     // Timestampのままだと、String <-> Timestampの変換がうまくできないため、
//     // TimestampをDateTimeのStringとして保持する。
//     if (json is String) {
//       final datetime = DateTime.parse(json);
//       final timestamp = Timestamp.fromDate(datetime);
//       return timestamp;
//     }

//     return null;
//   }
// }

// // --------------------------------------------------
// //
// //  CreatedAtTimestampConverter
// //
// // --------------------------------------------------
// class CreatedAtTimestampConverter extends JsonConverter<Timestamp?, dynamic> {
//   const CreatedAtTimestampConverter();

//   @override
//   dynamic toJson(Timestamp? object) {
//     if (object == null) return FieldValue.serverTimestamp();
//     return object;
//   }

//   @override
//   Timestamp? fromJson(dynamic json) {
//     if (json is Timestamp) return json;
//     return null;
//   }
// }

// --------------------------------------------------
//
//  FocusNodeConverter
//
// --------------------------------------------------
class FocusNodeConverter extends JsonConverter<FocusNode, String> {
  const FocusNodeConverter();

  @override
  String toJson(FocusNode object) {
    return object.toString();
  }

  @override
  FocusNode fromJson(String json) {
    return FocusNode();
  }
}

// --------------------------------------------------
//
//  SizeConverter
//
// --------------------------------------------------
class SizeConverter extends JsonConverter<Size, String> {
  const SizeConverter();

  @override
  String toJson(Size object) {
    final double width = object.width;
    final double height = object.height;
    final Map<String, double> jsonMap = {
      "width": width,
      "height": height,
    };
    return jsonEncode(jsonMap);
  }

  @override
  Size fromJson(String json) {
    final Map<String, dynamic> jsonMap = jsonDecode(json);
    final double width = jsonMap["width"];
    final double height = jsonMap["height"];

    return Size(width, height);
  }
}

// // --------------------------------------------------
// //
// //  DateTimeConverter
// //
// // --------------------------------------------------
// class DateTimeConverter extends JsonConverter<DateTime?, dynamic> {
//   const DateTimeConverter();

//   @override
//   String? toJson(DateTime? object) {
//     if (object == null) return null;

//     return object.toString();
//   }

//   @override
//   DateTime? fromJson(dynamic json) {
//     if (json is Timestamp) {
//       final dateTime = json.toDate();
//       return dateTime;
//     }

//     if (json is String) {
//       final datetime = DateTime.parse(json);
//       return datetime;
//     }

//     return null;
//   }
// }

// --------------------------------------------------
//
//  DateTimeConverter
//
// --------------------------------------------------
class DateTimeConverter extends JsonConverter<DateTime?, String?> {
  const DateTimeConverter();

  @override
  String? toJson(DateTime? object) {
    if (object == null) return null;

    return object.toString();
  }

  @override
  DateTime? fromJson(String? json) {
    if (json == null) return null;

    return DateTime.parse(json);
  }
}
