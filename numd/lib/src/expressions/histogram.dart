import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/bindings/numd_bindings.dart';
import 'package:numd/src/bindings/numd_dynamic_lib.dart';

ndarray histogramBinEdges(ndarray data, int nbins) {
  var binEdges = NumdBindings(NumdDynamicLib().xTensorLib).histogram_bin_edges(data.arrPtr, nbins);
  return ndarray.fromPointer(binEdges);
}

ndarray histogramCount(ndarray data, ndarray binEdges) {
  var count = NumdBindings(NumdDynamicLib().xTensorLib).histogram_count(data.arrPtr, binEdges.arrPtr);
  return ndarray.fromPointer(count);
}

(ndarray count, ndarray binEdges) histogram(ndarray data, int nbins) {
  ndarray binEdges = histogramBinEdges(data, nbins);
  ndarray count = histogramCount(data, binEdges);
  return (count, binEdges);
}