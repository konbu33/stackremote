// ignore_for_file: require_trailing_commas
// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// part of firebase_core_platform_interface;

import 'package:flutter/material.dart';

/// A generic class which provides exceptions in a Firebase-friendly format
/// to users.
///
/// ```dart
/// try {
///   await Firebase.initializeApp();
/// } on ChannelException catch (e) {
///   print(e.toString());
/// }
/// ```
@immutable
class StackremoteException implements Exception {
  /// A generic class which provides exceptions in a Firebase-friendly format
  /// to users.
  ///
  /// ```dart
  /// try {
  ///   await Firebase.initializeApp();
  /// } catch (e) {
  ///   print(e.toString());
  /// }
  /// ```
  const StackremoteException({
    required this.plugin,
    required this.message,
    String? code,
    this.stackTrace,
    // ignore: unnecessary_this
  }) : this.code = code ?? 'unknown';

  /// The plugin the exception is for.
  ///
  /// The value will be used to prefix the message to give more context about
  /// the exception.
  final String plugin;

  /// The long form message of the exception.
  final String message;

  /// The optional code to accommodate the message.
  ///
  /// Allows users to identify the exception from a short code-name, for example
  /// "no-app" is used when a user attempts to read a [FirebaseApp] which does
  /// not exist.
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StackremoteException) return false;
    return other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(plugin, code, message);

  @override
  String toString() {
    String output = '[$plugin/$code] $message';

    if (stackTrace != null) {
      output += '\n\n${stackTrace.toString()}';
    }

    return output;
  }
}
