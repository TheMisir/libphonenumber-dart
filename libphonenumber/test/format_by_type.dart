import 'dart:io';

import 'package:libphonenumber/libphonenumber.dart';
import 'package:libphonenumber/src/native/exception.dart';

String format(String input) {
  try {
    return PhoneNumber.parse('AZ', input).format(FormatMode.Rfc3966);
  } on NativeCallException {
    return input;
  }
}

void main() {
  while (true) {
    var line = stdin.readLineSync();
    if (line.isNotEmpty) {
      print(format(line));
    }
  }
}
