import 'package:numd/src/base/ndarray.dart';

ndarray empty(List<int> shape) {
  return ndarray.fromShape(shape);
}

ndarray zeros(List<int> shape) {
  return ndarray.fromShape(shape);
}

ndarray ones(List<int> shape) {
  return ndarray.fromShape(shape, filling: 1);
}

ndarray linspace(double start, double stop, int n) {
  ndarray arr = zeros([n]);
  for (var i = 0; i < n; i++) {
    arr.flat[i] = start + (stop - start) / (n - 1) * i;
  }
  return arr;
}

ndarray arange(int stop){
  ndarray arr = ndarray.fromShape([stop]);
  for (var i = 0; i < stop; i++) {
    arr.flat[i] = i.toDouble();
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
