// import 'package:flutter/foundation.dart';
// import 'package:hive_ce/hive.dart';
// import 'package:rxdart/rxdart.dart';
//
// extension HiveWatchExtensions on Box {
//   Stream<T?> watchItem<T>(dynamic key) {
//     return watch(
//       key: key,
//     ).map((event) => get(key) as T?).startWith(get(key) as T?);
//   }
//
//   Stream<T?> watchItemDistinct<T>(dynamic key) {
//     return watch(
//       key: key,
//     ).map((event) => get(key) as T?).startWith(get(key) as T?).distinct();
//   }
//
//   Stream<List<T>> watchAll<T>() {
//     return watch()
//         .map((_) => values.whereType<T>().toList())
//         .startWith(values.whereType<T>().toList());
//   }
//
//   Stream<List<T>> watchAllDistinct<T>() {
//     return watch()
//         .map((_) => values.whereType<T>().toList())
//         .startWith(values.whereType<T>().toList())
//         .distinct(listEquals);
//   }
// }
