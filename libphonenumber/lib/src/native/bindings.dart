import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'signatures.dart';
import 'structs.dart';

final bindings = PhoneNumberBindings();

const libphonenumber_native =
    '/mnt/d/workspace/repos/github.com/fonibo/libphonenumber/libphonenumber_native/target/debug/libphonenumber_bridge.so';

class PhoneNumberBindings {
  static final ptr = allocate<Pointer>();
  static final numberPtr = allocate<Pointer<IPhoneNumber>>();

  IPrint print;
  IParse parse;
  IIsViable isViable;
  IIsValid isValid;
  IFormat format;

  PhoneNumberBindings() {
    final dylib = DynamicLibrary.open(libphonenumber_native);

    Pointer<NativeFunction<T>> lookup<T extends Function>(String symbolName) {
      return dylib.lookup<NativeFunction<T>>('phonenumber_' + symbolName);
    }

    print = lookup<NIPrint>('print').asFunction();
    parse = lookup<NIParse>('parse').asFunction();
    isViable = lookup<NIIsViable>('is_viable').asFunction();
    isValid = lookup<NIIsValid>('is_valid').asFunction();
    format = lookup<NIFormat>('format').asFunction();
  }
}
