import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'structs.dart';

typedef NIPrint = Void Function(
  Pointer numberPtr,
);
typedef IPrint = void Function(
  Pointer numberPtr,
);

typedef NIParse = Uint8 Function(
  Pointer<Pointer<IPhoneNumber>> numberPtr,
  Pointer<Utf8> country,
  Pointer<Utf8> input,
);
typedef IParse = int Function(
  Pointer<Pointer<IPhoneNumber>> numberPtr,
  Pointer<Utf8> country,
  Pointer<Utf8> input,
);

typedef NIIsViable = Uint8 Function(
  Pointer<Utf8> input,
);
typedef IIsViable = int Function(
  Pointer<Utf8> input,
);

typedef NIIsValid = Uint8 Function(
  Pointer<IPhoneNumber> numberPtr,
);
typedef IIsValid = int Function(
  Pointer<IPhoneNumber> numberPtr,
);

typedef NIFormat = Pointer<Utf8> Function(
  Pointer<IPhoneNumber> numberPtr,
  Uint8 mode,
);
typedef IFormat = Pointer<Utf8> Function(
  Pointer<IPhoneNumber> numberPtr,
  int mode,
);
