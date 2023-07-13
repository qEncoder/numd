import 'package:numd/src/base/ndarray.dart';

ndarray empty(List<int> shape) {
  return ndarray.fromShape(shape, 0);
}

ndarray zeros(List<int> shape) {
  return ndarray.fromShape(shape, 0);
}

ndarray ones(List<int> shape) {
  return ndarray.fromShape(shape, 1);
}

ndarray linspace(double start, double stop, int n) {
  ndarray arr = zeros([n]);
  for (var i = 0; i < n; i++) {
    arr.flat[i] = start + (stop - start) / (n - 1) * i;
  }
  return arr;
}

ndarray eye(n) {
  ndarray arr = zeros([n, n]);
  for (var i = 0; i < n; i++) {
    arr[[i, i]] = 1;
  }
  return arr;
}
