import "package:numd/numd.dart";
import 'package:numd/iterators.dart';

dynamic average(ndarray array, {dynamic axis}) {
  if (axis == null) {
    double total = 0;
    for (double i in array.flat) {
      total += i;
    }
    return total / array.size;
  } else if (axis is int) {
    return average(array, axis: [axis]);
  } else if (axis is List<int>) {
    if (array.ndim == axis.length) return average(array);

    List<int> AxisToAverage = List.from(Range(array.ndim))..remove(axis);
  }
}
