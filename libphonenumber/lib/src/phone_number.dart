import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'formatter.dart';
import 'native/bindings.dart';
import 'native/native_call.dart';
import 'native/structs.dart';

class PhoneNumber {
  /// Parse a phone number.
  factory PhoneNumber.parse(String country, String input) {
    var ptr = PhoneNumberBindings.numberPtr;
    nativeCall(bindings.parse(ptr, Utf8.toUtf8(country), Utf8.toUtf8(input)));
    return PhoneNumber._(ptr.value);
  }

  PhoneNumber._(this._pointer)
      : code = _pointer.ref.code.ref,
        national = _pointer.ref.national.ref,
        carrier = Utf8.fromUtf8(_pointer.ref.carrier),
        extension = Utf8.fromUtf8(_pointer.ref.extension);

  /// Check if the provided string is a viable phone number.
  static bool isViable(String input) {
    return bindings.isViable(Utf8.toUtf8(input)) == 1;
  }

  final Pointer<IPhoneNumber> _pointer;

  /// The country calling code for this number, as defined by the International
  /// Telecommunication Union (ITU). For example, this would be 1 for NANPA
  /// countries, and 33 for France.
  final Code code;

  /// The National (significant) Number, as defined in International
  /// Telecommunication Union (ITU) Recommendation E.164, without any leading
  /// zero. The leading-zero is stored separately if required, since this is an
  /// uint64 and hence cannot store such information. Do not use this field
  /// directly: if you want the national significant number, call the
  /// getNationalSignificantNumber method of PhoneNumberUtil.
  ///
  /// For countries which have the concept of an "area code" or "national
  /// destination code", this is included in the National (significant) Number.
  /// Although the ITU says the maximum length should be 15, we have found
  /// longer numbers in some countries e.g. Germany.  Note that the National
  /// (significant) Number does not contain the National (trunk) prefix.
  /// Obviously, as a uint64, it will never contain any formatting (hyphens,
  /// spaces, parentheses), nor any alphanumeric spellings.
  final NationalNumber national;

  /// Extension is not standardized in ITU recommendations, except for being
  /// defined as a series of numbers with a maximum length of 40 digits. It is
  /// defined as a string here to accommodate for the possible use of a leading
  /// zero in the extension (organizations have complete freedom to do so, as
  /// there is no standard defined). Other than digits, some other dialling
  /// characters such as "," (indicating a wait) may be stored here.
  final String extension;

  /// The carrier selection code that is preferred when calling this phone
  /// number domestically. This also includes codes that need to be dialed in
  /// some countries when calling from landlines to mobiles or vice versa. For
  /// example, in Columbia, a "3" needs to be dialed before the phone number
  /// itself when calling from a mobile phone to a domestic landline phone and
  /// vice versa.
  ///
  /// Note this is the "preferred" code, which means other codes may work as
  /// well.
  final String carrier;

  /// Check if the phone number is valid.
  bool isValid() {
    return bindings.isValid(_pointer) == 1;
  }

  /// Format phone number by [mode].
  String format(FormatMode mode) {
    var result = bindings.format(_pointer, mode.toInt());
    return Utf8.fromUtf8(result);
  }

  /// Pretty print phone number info.
  void print() {
    bindings.print(_pointer);
  }
}
