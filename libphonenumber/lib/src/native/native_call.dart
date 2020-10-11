import 'exception.dart';

void nativeCall(int result, [String message]) {
  if (result != 0) {
    throw NativeCallException(result, message);
  }
}
