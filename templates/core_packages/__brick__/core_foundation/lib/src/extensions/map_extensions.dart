import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_foundation/src/extensions/deep_pick_extensions.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/foundation.dart';

extension MapDeepPickX on Map<String, dynamic> {
  void print() {
    debugPrint(const JsonEncoder.withIndent('  ').convert(this));
  }

  /// Base picker that accepts an ordered [List<Object>] representing the JSON path.
  /// Elements in the list can be [String] (for keys) or [int] (for indices).
  Pick _pick(List<Object> path) {
    return pickDeep(this, path);
  }

  // =========================================================================
  // Nullable Shortcuts (Explicitly Named)
  // =========================================================================

  /// Direct type-safe lookup for a [String]. Returns null if missing or mismatched.
  String? pickStringOrNull(List<Object> path) => _pick(path).asStringOrNull();

  /// Direct type-safe lookup for an [int]. Returns null if missing or mismatched.
  int? pickIntOrNull(List<Object> path) => _pick(path).asIntOrNull();

  /// Direct type-safe lookup for a [double]. Returns null if missing or mismatched.
  double? pickDoubleOrNull(List<Object> path) => _pick(path).asDoubleOrNull();

  /// Direct type-safe lookup for a [bool]. Returns null if missing or mismatched.
  bool? pickBoolOrNull(List<Object> path) => _pick(path).asBoolOrNull();

  /// Direct type-safe lookup for a [DateTime]. Returns null if missing or mismatched.
  DateTime? pickDateTimeOrNull(List<Object> path) =>
      _pick(path).asDateTimeOrNull();

  Timestamp? pickTimestampOrNull(List<Object> path) {
    return _pick(path).asTimeStampOrNull();
  }

  /// Direct type-safe lookup for a nested [Map]. Returns null if missing or mismatched.
  Map<String, dynamic>? pickMapOrNull(List<Object> path) =>
      _pick(path).asMapOrNull<String, dynamic>();

  // =========================================================================
  // OrDefault Shortcuts (Required Fallbacks)
  // =========================================================================

  /// Direct lookup for a [String]. Returns [defaultValue] if missing or mismatched.
  String pickStringOrDefault(
    List<Object> path, {
    required String defaultValue,
  }) => pickStringOrNull(path) ?? defaultValue;

  /// Direct lookup for an [int]. Returns [defaultValue] if missing or mismatched.
  int pickIntOrDefault(List<Object> path, {required int defaultValue}) =>
      pickIntOrNull(path) ?? defaultValue;

  /// Direct lookup for a [double]. Returns [defaultValue] if missing or mismatched.
  double pickDoubleOrDefault(
    List<Object> path, {
    required double defaultValue,
  }) => pickDoubleOrNull(path) ?? defaultValue;

  /// Direct lookup for a [bool]. Returns [defaultValue] if missing or mismatched.
  bool pickBoolOrDefault(List<Object> path, {required bool defaultValue}) =>
      pickBoolOrNull(path) ?? defaultValue;

  /// Direct lookup for a [DateTime]. Returns [defaultValue] if missing or mismatched.
  DateTime? pickDateTimeOrDefault(
    List<Object> path, {
    required DateTime? defaultValue,
  }) => pickDateTimeOrNull(path) ?? defaultValue;

  Timestamp? pickTimestampOrDefault(
    List<Object> path, {
    required Timestamp? defaultValue,
  }) {
    return _pick(path).asTimeStampOrNull() ?? defaultValue;
  }

  /// Direct lookup for a nested [Map]. Returns [defaultValue] if missing or mismatched.
  Map<String, dynamic> pickMapOrDefault(
    List<Object> path, {
    required Map<String, dynamic> defaultValue,
  }) => pickMapOrNull(path) ?? defaultValue;

  /// Direct type-safe lookup for a [List] of typed objects using a custom mapper.
  /// Returns an empty list if the path is invalid or missing.
  List<R> pickList<R>(List<Object> path, R Function(Pick) mapFunction) {
    return _pick(path).asListOrEmpty(mapFunction);
  }
}
