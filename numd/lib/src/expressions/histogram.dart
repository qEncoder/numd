import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/bindings/numd_bindings.dart';
import 'package:numd/src/bindings/numd_dynamic_lib.dart';

(ndarray count, ndarray bin_edges) histogram(ndarray arr, int nbins) {
  histogram_pointers hist_pointer =
      NumdBindings(NumdDynamicLib().xTensorLib).histogram(arr.arrPtr, nbins);
  ndarray count = ndarray.fromPointer(hist_pointer.count);
  ndarray bin_edges = ndarray.fromPointer(hist_pointer.bin_edges);
  return (count, bin_edges);
}
