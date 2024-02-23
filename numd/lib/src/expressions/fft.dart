import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/array_generators.dart';

import 'package:numd/src/bindings/numd_dynamic_lib.dart';
import 'package:numd/src/bindings/numd_bindings.dart';

rFFT(ndarray array) {
  if (array.ndim != 1) throw "innapropriate number of dimensions";

  return ndarray.fromPointer(
      NumdBindings(NumdDynamicLib().xTensorLib).rfft(array.arrPtr));
}

rFFT2(ndarray array) {
  if (array.ndim != 2) throw "innapropriate number of dimensions";

  return ndarray.fromPointer(
      NumdBindings(NumdDynamicLib().xTensorLib).rfft2(array.arrPtr));
}

rFFTfreq(int npoints, double distance) {
  int npt_out = (npoints/2).floor()+1;
  if (npoints % 2 == 0) { // even
    return linspace(0, 0.5/distance, npt_out);
  } else { // odd
    return linspace(0, 0.5*(npoints-1)/npoints/distance, npt_out);
  }
}
