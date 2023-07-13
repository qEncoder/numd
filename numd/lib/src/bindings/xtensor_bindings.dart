import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

class XtensorBindings {
  static final XtensorBindings __instance = XtensorBindings.__new__();
  late final DynamicLibrary xTensorLib;
  factory XtensorBindings() {
    return __instance;
  }

  XtensorBindings.__new__() {
    String libraryPath =
        path.join(Directory.current.path, 'clib', 'libxtensor_dart_ffi.so');
    if (Platform.isMacOS) {
      libraryPath = path.join(
          Directory.current.path, 'clib', 'libxtensor_dart_ffi.dylib');
    } else if (Platform.isWindows) {
      libraryPath =
          path.join(Directory.current.path, 'clib', 'libxtensor_dart_ffi.dll');
    }

    xTensorLib = DynamicLibrary.open(libraryPath);
  }
}
