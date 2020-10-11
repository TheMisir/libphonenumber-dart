enum FormatMode {
  E164,
  International,
  National,
  Rfc3966,
}

extension FormatModeX on FormatMode {
  toInt() {
    switch (this) {
      case FormatMode.E164:
        return 0;

      case FormatMode.International:
        return 1;

      case FormatMode.National:
        return 2;

      case FormatMode.Rfc3966:
        return 3;
    }
  }
}
