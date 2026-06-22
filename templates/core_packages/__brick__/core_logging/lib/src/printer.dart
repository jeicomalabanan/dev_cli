void printInfo(Object? object) {
  print('[INFO] $object');
}

void printDebug(Object? object) {
  print('[DEBUG] $object');
}

void printWarn(Object? object) {
  print('[WARN] $object');
}

void printError(Object? object) {
  print('[ERROR] $object');
}

void printStack(Object? object, StackTrace? stackTrace) {
  print('[ERROR] $object');
  print('[ERROR] $stackTrace');
}
