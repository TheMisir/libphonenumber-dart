import 'dart:ffi' as ffi;

typedef hello_world_func = ffi.Void Function();

typedef HelloWorld = void Function();

final dylib = ffi.DynamicLibrary.open('hello_world.dylib');

final HelloWorld hello = dylib
    .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
    .asFunction();
