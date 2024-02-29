import 'dart:ffi';
import 'dart:io';

class NumdDynamicLib {
  static final NumdDynamicLib __instance = NumdDynamicLib.__new__();
  late final DynamicLibrary xTensorLib;
  factory NumdDynamicLib() {
    return __instance;
  }

  NumdDynamicLib.__new__() {
    String library = 'libnumd.so';
    if (Platform.isMacOS) {
      library = 'libnumd.dylib';
    } else if (Platform.isWindows) {
      library = 'numd_c_libs.dll';
    }
    xTensorLib = DynamicLibrary.open(library);
  }
}
