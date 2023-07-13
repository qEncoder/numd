import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/bindings/xtensor_expressions_bindings.dart';

rFFT(ndarray array) {
  if (array.ndim != 1) throw "innapropriate number of dimensions";

  return ndarray.fromPointer(XtensorExpressions().rFFT(array.arrPtr));
}

rFFT2(ndarray array) {
  if (array.ndim != 2) throw "innapropriate number of dimensions";

  return ndarray.fromPointer(XtensorExpressions().rFFT2(array.arrPtr));
}

rFFTfreq(int npoints, double distance) {
  return ndarray.fromPointer(XtensorExpressions().rFFTfreq(npoints, distance));
}
