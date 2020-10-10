import 'dart:ffi' as ffi;

typedef hello_world_func = ffi.Void Function();

typedef HelloWorld = void Function();

final dylib = ffi.DynamicLibrary.open(
    '/mnt/d/workspace/repos/github.com/fonibo/libphonenumber/libphonenumber_native/target/debug/libphonenumber.so');

final HelloWorld hello = dylib
    .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
    .asFunction();

void main() {
  hello();
}
