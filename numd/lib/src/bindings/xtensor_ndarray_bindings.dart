import 'package:numd/src/bindings/xtensor_bindings.dart';

import 'dart:ffi';

final class c_slice extends Struct {
  @Uint64()
  external int start;

  @Uint64()
  external int stop;

  @Bool()
  external bool noRange;
}

typedef create_xarray_c = Pointer<Void> Function(
    Int64 ndim, Pointer<Int64> shape, Double fill);
typedef create_xarray = Pointer<Void> Function(
    int ndim, Pointer<Int64> shape, double fill);

typedef delete_xarray_c = Void Function(Pointer<Void>);
typedef delete_xarray = void Function(Pointer<Void>);

typedef get_ndim_c = Int64 Function(Pointer<Void> ptr);
typedef get_ndim = int Function(Pointer<Void> ptr);

typedef get_size_c = Int64 Function(Pointer<Void> ptr);
typedef get_size = int Function(Pointer<Void> ptr);

typedef get_shape_c = Void Function(Pointer<Void> ptr, Pointer<Int64> shape);
typedef get_shape = void Function(Pointer<Void> ptr, Pointer<Int64> shape);

typedef slice_array_c = Pointer<Void> Function(
    Pointer<Void> ptr, Pointer<c_slice> slices, Int64 n_slices);
typedef slice_array = Pointer<Void> Function(
    Pointer<Void> ptr, Pointer<c_slice> slices, int n_slices);

typedef assign_array_to_slice_c = Void Function(Pointer<Void> ptr_1,
    Pointer<Void> ptr_2, Pointer<c_slice> slices, Int64 n_slices);
typedef assign_array_to_slice = void Function(Pointer<Void> ptr_1,
    Pointer<Void> ptr_2, Pointer<c_slice> slices, int n_slices);

typedef assign_double_to_slice_c = Void Function(
    Pointer<Void> ptr, Double value, Pointer<c_slice> slices, Int64 n_slices);
typedef assign_double_to_slice = void Function(
    Pointer<Void> ptr, double value, Pointer<c_slice> slices, int n_slices);

typedef Tranpose_c = Pointer<Void> Function(Pointer<Void> ptr);
typedef Tranpose = Pointer<Void> Function(Pointer<Void> ptr);

typedef add_arrays_c = Pointer<Void> Function(
    Pointer<Void> ptr_1, Pointer<Void> ptr_2);
typedef add_arrays = Pointer<Void> Function(
    Pointer<Void> ptr_1, Pointer<Void> ptr_2);

typedef add_double_c = Pointer<Void> Function(
    Pointer<Void> ptr_1, Double value);
typedef add_double = Pointer<Void> Function(Pointer<Void> ptr_1, double value);

typedef substract_arrays_c = Pointer<Void> Function(
    Pointer<Void> ptr_1, Pointer<Void> ptr_2);
typedef substract_arrays = Pointer<Void> Function(
    Pointer<Void> ptr_1, Pointer<Void> ptr_2);

typedef substract_double_c = Pointer<Void> Function(
    Pointer<Void> ptr_1, Double value);
typedef substract_double = Pointer<Void> Function(
    Pointer<Void> ptr_1, double value);

typedef multiply_arrays_c = Pointer<Void> Function(
    Pointer<Void> ptr_1, Pointer<Void> ptr_2);
typedef multiply_arrays = Pointer<Void> Function(
    Pointer<Void> ptr_1, Pointer<Void> ptr_2);

typedef multiply_double_c = Pointer<Void> Function(
    Pointer<Void> ptr_1, Double value);
typedef multiply_double = Pointer<Void> Function(
    Pointer<Void> ptr_1, double value);

typedef divide_arrays_c = Pointer<Void> Function(
    Pointer<Void> ptr_1, Pointer<Void> ptr_2);
typedef divide_arrays = Pointer<Void> Function(
    Pointer<Void> ptr_1, Pointer<Void> ptr_2);

typedef divide_double_c = Pointer<Void> Function(
    Pointer<Void> ptr_1, Double value);
typedef divide_double = Pointer<Void> Function(
    Pointer<Void> ptr_1, double value);

typedef assign_flat_c = Void Function(
    Pointer<Void> ptr_1, Int64 idx, Double value);
typedef assign_flat = void Function(Pointer<Void> ptr_1, int idx, double value);

typedef return_flat_c = Double Function(Pointer<Void> ptr_1, Int64 idx);
typedef return_flat = double Function(Pointer<Void> ptr_1, int idx);

typedef print_array_c = Void Function(Pointer<Void> ptr);
typedef print_array = void Function(Pointer<Void> ptr);

class XtensorNdArray {
  static final XtensorNdArray __instance = XtensorNdArray.__new__();
  late final create_xarray createXArray;
  late final delete_xarray deleteXArray;
  late final Pointer<NativeFunction<Void Function(Pointer<Void>)>>
      deleteXArrayNative;

  late final slice_array sliceArray;
  late final assign_array_to_slice assignArrayToSlice;
  late final assign_double_to_slice assignDoubleToSlice;

  late final Tranpose transpose;

  late final get_size getSize;
  late final get_ndim getNDim;
  late final get_shape getShape;

  late final add_arrays addArrays;
  late final add_double addDouble;

  late final substract_arrays substractArrays;
  late final substract_double substractDouble;

  late final multiply_arrays multiplyArrays;
  late final multiply_double multiplyDouble;

  late final divide_arrays divideArrays;
  late final divide_double divideDouble;

  late final assign_flat assignFlat;
  late final return_flat returnFlat;

  late final print_array printArray;

  factory XtensorNdArray() {
    return __instance;
  }

  XtensorNdArray.__new__() {
    final DynamicLibrary xTensorLib = XtensorBindings().xTensorLib;

    createXArray = xTensorLib
        .lookup<NativeFunction<create_xarray_c>>("create_xarray")
        .asFunction();
    deleteXArray = xTensorLib
        .lookup<NativeFunction<delete_xarray_c>>("delete_xarray")
        .asFunction();
    deleteXArrayNative =
        xTensorLib.lookup<NativeFunction<delete_xarray_c>>("delete_xarray");

    getSize =
        xTensorLib.lookup<NativeFunction<get_size_c>>("get_size").asFunction();
    getNDim =
        xTensorLib.lookup<NativeFunction<get_ndim_c>>("get_ndim").asFunction();
    getShape = xTensorLib
        .lookup<NativeFunction<get_shape_c>>("get_shape")
        .asFunction();

    sliceArray = xTensorLib
        .lookup<NativeFunction<slice_array_c>>("slice_array")
        .asFunction();
    assignArrayToSlice = xTensorLib
        .lookup<NativeFunction<assign_array_to_slice_c>>(
            "assign_array_to_slice")
        .asFunction();
    assignDoubleToSlice = xTensorLib
        .lookup<NativeFunction<assign_double_to_slice_c>>(
            "assign_double_to_slice")
        .asFunction();

    transpose =
        xTensorLib.lookup<NativeFunction<Tranpose_c>>("transpose").asFunction();

    addArrays = xTensorLib
        .lookup<NativeFunction<add_arrays_c>>("add_arrays")
        .asFunction();
    addDouble = xTensorLib
        .lookup<NativeFunction<add_double_c>>("add_double")
        .asFunction();

    substractArrays = xTensorLib
        .lookup<NativeFunction<substract_arrays_c>>("substract_arrays")
        .asFunction();
    substractDouble = xTensorLib
        .lookup<NativeFunction<substract_double_c>>("substract_double")
        .asFunction();

    multiplyArrays = xTensorLib
        .lookup<NativeFunction<multiply_arrays_c>>("multiply_arrays")
        .asFunction();
    multiplyDouble = xTensorLib
        .lookup<NativeFunction<multiply_double_c>>("multiply_double")
        .asFunction();

    divideArrays = xTensorLib
        .lookup<NativeFunction<divide_arrays_c>>("divide_arrays")
        .asFunction();
    divideDouble = xTensorLib
        .lookup<NativeFunction<divide_double_c>>("divide_double")
        .asFunction();

    assignFlat = xTensorLib
        .lookup<NativeFunction<assign_flat_c>>("assign_flat")
        .asFunction();
    returnFlat = xTensorLib
        .lookup<NativeFunction<return_flat_c>>("return_flat")
        .asFunction();

    printArray = xTensorLib
        .lookup<NativeFunction<print_array_c>>("print_array")
        .asFunction();
  }
}
