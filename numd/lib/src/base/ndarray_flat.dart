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
    index = __check_index(index);
    return xtensorNdArray.return_flat(parent.arrPtr, index);
  }

  void operator []=(int index, double value) {
    index = __check_index(index);
    xtensorNdArray.assign_flat(parent.arrPtr, index, value);
  }

  int __check_index(int index) {
    if (index < 0) index += size;
    if (index < 0 || index >= size) {
      throw RangeError.index(index, this, 'index', 'Index out of range');
    }
    return index;
  }
}
