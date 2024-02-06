import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/bindings/numd_bindings.dart';
import 'package:numd/src/bindings/numd_dynamic_lib.dart';


ndarray transpose(ndarray arr){
  return ndarray.fromPointer(
      NumdBindings(NumdDynamicLib().xTensorLib).transpose(arr.arrPtr));
}

ndarray swapaxes(ndarray arr, int axis1, int axis2) {
  return ndarray.fromPointer(
      NumdBindings(NumdDynamicLib().xTensorLib).swapaxes(arr.arrPtr, axis1, axis2));
}

ndarray flip(ndarray arr, int axis) {
  return ndarray.fromPointer(
      NumdBindings(NumdDynamicLib().xTensorLib).flip(arr.arrPtr, axis));
}