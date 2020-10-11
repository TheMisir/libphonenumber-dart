import 'package:libphonenumber/libphonenumber.dart';
import 'package:libphonenumber/src/native/exception.dart';
import 'package:test/test.dart';

void parseAll(List<String> nums, Matcher matcher) {
  nums.forEach((s) {
    expect(() => PhoneNumber.parse('GE', s), matcher, reason: 'parsing $s');
  });
}

void main() {
  group('PhoneNumber', () {
    test('x', () {
      var numb = PhoneNumber.parse('GE', '051 61254 33');
      var x = numb.format(FormatMode.International);
      var e;
    });

    group('.parse()', () {
      test('valid values', () {
        parseAll([
          '+145436',
          '05 55 5 5 5 555',
          '+435343454354',
          '+994112223344',
        ], isNotNull);
      });

      test('invalid values', () {
        parseAll([
          '+1',
          '+2334jdhsdfhjsadasdasdasdd',
          '+38888888888888888888888888888888888888',
          '',
        ], throwsA(isA<NativeCallException>()));
      });
    });
  });
}
