import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/bindings/xtensor_expressions_bindings.dart';

dynamic _reduction(ndarray array, Function func, {dynamic axis}) {
  ndarray result;
  if (axis == null) {
    return _reduction(array, func,
        axis: List<int>.generate(array.ndim, (idx) => idx));
  } else if (axis is int) {
    return _reduction(array, func, axis: [axis]);
  } else if (axis is List<int>) {
    axis = axis.toSet().toList()..sort();
    Pointer<Int64> axes = calloc<Int64>(axis.length);
    for (var i = 0; i < axis.length; i++) {
      axes[i] = axis[i];
    }
    result = ndarray.fromPointer(func(array.arrPtr, axes, axis.length));
    calloc.free(axes);

    if (result.size == 1) {
      return result.flat[0];
    } else {
      return result;
    }
  }
}

dynamic average(ndarray array, {dynamic axis}) {
  return mean(array, axis: axis);
}

dynamic mean(ndarray array, {dynamic axis}) {
  return _reduction(array, XtensorExpressions().mean, axis: axis);
}

dynamic min(ndarray array, {dynamic axis}) {
  return _reduction(array, XtensorExpressions().min, axis: axis);
}

dynamic max(ndarray array, {dynamic axis}) {
  return _reduction(array, XtensorExpressions().max, axis: axis);
}

ndarray normalize(ndarray array) {
  return ndarray.fromPointer(XtensorExpressions().normalize(array.arrPtr));
}
