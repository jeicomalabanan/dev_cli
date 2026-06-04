import 'dart:io';

final class FileUtil {
  FileUtil._();

  static Future<void> deletePath(String path) async {
    if (path.isEmpty) return;

    try {
      final entity = FileSystemEntity.typeSync(path);

      switch (entity) {
        case FileSystemEntityType.file:
          await File(path).delete();
          break;
        case FileSystemEntityType.directory:
          await Directory(path).delete(recursive: true);
          break;
        default:
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deletePaths(List<String> paths) async {
    for (final path in paths) {
      await deletePath(path);
    }
  }
}
