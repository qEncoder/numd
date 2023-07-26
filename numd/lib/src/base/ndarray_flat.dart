import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/bindings/numd_bindings.dart';
import 'package:numd/src/bindings/numd_dynamic_lib.dart';

class ndArrayFlat {
  final ndarray parent;
  static final NumdBindings xtensorNdArray =
      NumdBindings(NumdDynamicLib().xTensorLib);
  ndArrayFlat(this.parent);

  int get ndim => 1;
  int get size => parent.size;
  List<int> get shape => [parent.size];

  double operator [](int index) {
    return xtensorNdArray.return_flat(parent.arrPtr, index);
  }

  void operator []=(int index, double value) {
    xtensorNdArray.assign_flat(parent.arrPtr, index, value);
  }
}
