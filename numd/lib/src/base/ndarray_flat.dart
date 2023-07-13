import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/bindings/xtensor_ndarray_bindings.dart';

class ndArrayFlat {
  final ndarray parent;
  static final XtensorNdArray xtensorNdArray = XtensorNdArray();
  ndArrayFlat(this.parent);

  int get ndim => 1;
  int get size => parent.size;
  List<int> get shape => [parent.size];

  double operator [](int index) {
    return xtensorNdArray.returnFlat(parent.arrPtr, index);
  }

  void operator []=(int index, double value) {
    xtensorNdArray.assignFlat(parent.arrPtr, index, value);
  }
}
