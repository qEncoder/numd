import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

class XtensorBindings {
  static final XtensorBindings __instance = XtensorBindings.__new__();
  late final DynamicLibrary xTensorLib;
  factory XtensorBindings() {
    print("loading instace");
    return __instance;
  }

  XtensorBindings.__new__() {
    // TODO find the right way to do this when releasing.
    String libraryPath = path.join(
        Directory.current.path, '..', 'numd', 'clib', 'libxtensor_dart_ffi.so');
    if (Platform.isMacOS) {
      libraryPath = path.join(Directory.current.path, '..', 'numd', 'clib',
          'libxtensor_dart_ffi.dylib');
    } else if (Platform.isWindows) {
      libraryPath = path.join(Directory.current.path, '..', 'numd', 'clib',
          'libxtensor_dart_ffi.dll');
    }
    print("bindings loaded");
    xTensorLib = DynamicLibrary.open(libraryPath);
  }
}
