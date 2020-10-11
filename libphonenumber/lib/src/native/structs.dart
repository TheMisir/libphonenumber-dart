import 'dart:ffi';

import 'package:ffi/ffi.dart';

class Code extends Struct {
  /// The country code value.
  @Uint16()
  int value;

  @Uint8()
  int _source;

  /// The source from which the country code is derived.
  CodeSource get source => CodeSource.values[_source];
}

/// The source from which the country code is derived. This is not set in the
/// general parsing method, but in the method that parses and keeps raw_input.
enum CodeSource {
  /// The country code is derived based on a phone number with a leading "+",
  /// e.g. the French number "+33 1 42 68 53 00".
  Plus,

  /// The country code is derived based on a phone number with a leading IDD,
  /// e.g. the French number "011 33 1 42 68 53 00", as it is dialled from US.
  Idd,

  /// The country code is derived based on a phone number without a leading
  /// "+", e.g. the French number "33 1 42 68 53 00" when the default country
  /// is supplied as France.
  Number,

  /// The country code is derived NOT based on the phone number itself, but
  /// from the default country parameter provided in the parsing function by
  /// the clients. This happens mostly for numbers written in the national
  /// format (without country code). For example, this would be set when
  /// parsing the French number "01 42 68 53 00", when the default country is
  /// supplied as France.
  Default,
}

/// The national number part of a phone number.
class NationalNumber extends Struct {
  @Uint64()
  int value;

  /// In some countries, the national (significant) number starts with one or
  /// more "0"s without this being a national prefix or trunk code of some
  /// kind.  For example, the leading zero in the national (significant) number
  /// of an Italian phone number indicates the number is a fixed-line number.
  /// There have been plans to migrate fixed-line numbers to start with the
  /// digit two since December 2000, but it has not happened yet. See
  /// http://en.wikipedia.org/wiki/%2B39 for more details.
  ///
  /// These fields can be safely ignored (there is no need to set them) for
  /// most countries. Some limited number of countries behave like Italy - for
  /// these cases, if the leading zero(s) of a number would be retained even
  /// when dialling internationally, set this flag to true, and also set the
  /// number of leading zeros.
  ///
  /// Clients who use the parsing or conversion functionality of the i18n phone
  /// number libraries will have these fields set if necessary automatically.
  @Uint8()
  int zeros;
}

/// A phone number.
class IPhoneNumber extends Struct {
  Pointer<Code> code;
  Pointer<NationalNumber> national;
  Pointer<Utf8> extension;
  Pointer<Utf8> carrier;
}
