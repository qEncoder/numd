import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/base/view.dart';
import 'package:numd/src/utility/iterators.dart';

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
    if (axis.isEmpty) return average(array);

    List<int> invAxis = [];
    List slice = List.generate(
        array.ndim, (int idx) => (axis.contains(idx)) ? 0 : Slice(0, -1));

    for (int i in Range(array.ndim)) {
      if (!axis.contains(i)) invAxis.add(i);
    }
    ndarray avg = ndarray(array[slice].shape);
    for (List<int> idx in avg.view.indexIterator) {
      slice = List.generate(array.ndim, (int index) => Slice(0, -1));
      for (int index in Range(idx.length)) {
        slice[invAxis[index]] = idx[index];
      }
      avg[idx] = average(array[slice]);
    }

    return avg;
  }
}
