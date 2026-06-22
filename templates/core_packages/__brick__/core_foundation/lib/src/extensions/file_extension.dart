import 'dart:io';

import 'package:path/path.dart';

extension FileExtension on File {
  /// Converts bytes to GB (decimal)
  /// Decimal: 1000 bytes = 1 KB. 1000 KB = 1 MB. 1000 MB = 1 GB
  /// Binary: 1024 bytes = 1 KB. 1024 KB = 1 MB. 1024 MB = 1 GB
  Future<double> get sizeInGb async {
    final bytes = await length();
    return bytes / (1000 * 1000 * 1000);
  }

  /// Gets the part of [path] after the last separator.
  ///
  ///     p.basename('path/to/foo.dart'); // -> 'foo.dart'
  ///     p.basename('path/to');          // -> 'to'
  ///
  /// Trailing separators are ignored.
  ///
  ///     p.basename('path/to/'); // -> 'to'
  String get filename => basename(path);

  /// Gets the part of [path] after the last separator, and without any trailing
  /// file extension.
  ///
  ///     p.basenameWithoutExtension('path/to/foo.dart'); // -> 'foo'
  ///
  /// Trailing separators are ignored.
  ///
  ///     p.basenameWithoutExtension('path/to/foo.dart/'); // -> 'foo'
  String get filenameWithoutExtension => basenameWithoutExtension(path);

  /// Gets the file extension of [path]: the portion of [basename] from the last
  /// `.` to the end (including the `.` itself).
  ///
  ///     p.extension('path/to/foo.dart');    // -> '.dart'
  ///     p.extension('path/to/foo');         // -> ''
  ///     p.extension('path.to/foo');         // -> ''
  ///     p.extension('path/to/foo.dart.js'); // -> '.js'
  ///
  /// If the file name starts with a `.`, then that is not considered the
  /// extension:
  ///
  ///     p.extension('~/.bashrc');    // -> ''
  ///     p.extension('~/.notes.txt'); // -> '.txt'
  ///
  /// Takes an optional parameter `level` which makes possible to return
  /// multiple extensions having `level` number of dots. If `level` exceeds the
  /// number of dots, the full extension is returned. The value of `level` must
  /// be greater than 0, else `RangeError` is thrown.
  ///
  ///     p.extension('foo.bar.dart.js', 2);   // -> '.dart.js
  ///     p.extension('foo.bar.dart.js', 3);   // -> '.bar.dart.js'
  ///     p.extension('foo.bar.dart.js', 10);  // -> '.bar.dart.js'
  ///     p.extension('path/to/foo.bar.dart.js', 2);  // -> '.dart.js'
  String get fileExtension => extension(path);
}
