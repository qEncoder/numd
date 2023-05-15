import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/base/view.dart';

import 'package:numd/src/utility/iterators.dart';

ndarray empty(List<int> shape) {
  return ndarray(shape);
}

ndarray zeros(List<int> shape) {
  return ndarray(shape);
}

ndarray ones(List<int> shape) {
  var arr = ndarray(shape);
  arr.flat[Slice(0, -1)] = 1;
  return arr;
}

ndarray linspace(double start, double stop, int n) {
  var arr = ndarray([n]);
  for (int i in Range(n)) {
    arr.data[i] = start + (stop - start) / (n - 1) * i;
  }
  return arr;
}

ndarray eye(n) {
  var arr = zeros([n, n]);
  for (int i in Range(n)) {
    arr[[i, i]] = 1;
  }
  return arr;
}
