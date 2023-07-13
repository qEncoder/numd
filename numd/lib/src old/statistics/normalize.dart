import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/statistics/min_max.dart';

ndarray normalize(ndarray array) {
  double minVal = min(array);
  double maxVal = max(array);

  if (maxVal == minVal) {
    return array - minVal;
  }
  return (array - minVal) / (maxVal - minVal);
}
