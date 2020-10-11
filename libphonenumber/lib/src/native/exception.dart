class NativeCallException implements Exception {
  final dynamic message;
  final int code;

  NativeCallException(this.code, [this.message]);

  String toString() {
    if (message == null) return "NativeCallException ($code)";
    return "NativeCallException ($code): $message";
  }
}
