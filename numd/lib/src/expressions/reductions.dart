import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/bindings/numd_bindings.dart';
import 'package:numd/src/bindings/numd_dynamic_lib.dart';

dynamic _reduction(ndarray array, Function func, {dynamic axis}) {
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
    ndarray result = ndarray.fromPointer(func(array.arrPtr, axes, axis.length));
    calloc.free(axes);
  
    if (array.ndim == axis.length) {
      return result.flat[0];
    }

    return result;
  }
}

dynamic average(ndarray array, {dynamic axis}) {
  return mean(array, axis: axis);
}

dynamic mean(ndarray array, {List<int>? axis}) {
  return _reduction(array, NumdBindings(NumdDynamicLib().xTensorLib).mean,
      axis: axis);
}

dynamic nanmean(ndarray array, {List<int>? axis}) {
  return _reduction(array, NumdBindings(NumdDynamicLib().xTensorLib).nanmean,
      axis: axis);
}

dynamic min(ndarray array, {dynamic axis}) {
  return _reduction(array, NumdBindings(NumdDynamicLib().xTensorLib).min,
      axis: axis);
}

dynamic max(ndarray array, {dynamic axis}) {
  return _reduction(array, NumdBindings(NumdDynamicLib().xTensorLib).max,
      axis: axis);
}

dynamic nanmin(ndarray array, {dynamic axis}) {
  return _reduction(array, NumdBindings(NumdDynamicLib().xTensorLib).nanmin,
      axis: axis);
}

dynamic nanmax(ndarray array, {dynamic axis}) {
  return _reduction(array, NumdBindings(NumdDynamicLib().xTensorLib).nanmax,
      axis: axis);
}

ndarray normalize(ndarray array) {
  return ndarray.fromPointer(
      NumdBindings(NumdDynamicLib().xTensorLib).normalize(array.arrPtr));
}
