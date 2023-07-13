import 'package:numd/src/base/ndarray.dart';

double min(ndarray array) { 
  double minValue = array.flat[0];

  for (double i in array.flat) {
    if (i < minValue) minValue = i;
  }
  return minValue;
}

double max(ndarray array) {
  double maxValue = array.flat[0];

  for (double i in array.flat) {
    if (i > maxValue) maxValue = i;
  }
  return maxValue;
}
