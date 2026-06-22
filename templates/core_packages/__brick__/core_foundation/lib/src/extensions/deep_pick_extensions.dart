import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_pick/deep_pick.dart';

extension TimestampPick on Pick {
  Timestamp asTimeStampOrThrow() {
    final value = required().value;
    if (value is Timestamp) {
      return value;
    }
    if (value is int) {
      return Timestamp.fromMillisecondsSinceEpoch(value);
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to Timestamp",
    );
  }

  Timestamp? asTimeStampOrNull() {
    if (value == null) return null;
    try {
      return asTimeStampOrThrow();
    } catch (_) {
      return null;
    }
  }
}
