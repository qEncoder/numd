import 'dart:ffi';
import 'dart:io';

class NumdDynamicLib {
  static final NumdDynamicLib __instance = NumdDynamicLib.__new__();
  late final DynamicLibrary xTensorLib;
  factory NumdDynamicLib() {
    return __instance;
  }

  NumdDynamicLib.__new__() {
    // TODO find the right way to do this when releasing.
    String library = 'libnumd.so';
    if (Platform.isMacOS) {
      library = 'libnumd.dylib';
    } else if (Platform.isWindows) {
      library = 'libnumd.dll';
    }
    xTensorLib = DynamicLibrary.open(library);
  }
}
