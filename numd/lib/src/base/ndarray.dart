import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:numd/src/base/ndarray_flat.dart';
import 'package:numd/src/bindings/numd_bindings.dart';

import 'package:numd/src/bindings/numd_dynamic_lib.dart';

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:numd/src/utility/iterators.dart';

class Slice {
  int start;
  int? stop;
  int step;

  Slice(this.start, [this.stop, this.step = 1]);

  @override
  String toString() {
    return "Slice of array, start : $start | stop : $stop";
  }

  int get size{
    if (stop != null && stop! >= 0) return ((stop! - start)/step.toDouble()).ceil();
    return -1;
  }

  Slice getFormattedSlice(int shape){
    int newStart = start;
    int newStop = stop ?? shape;
    if (newStart < 0) newStart = shape + start;
    if (newStop < 0) newStop = shape + stop!;
    return Slice(newStart, newStop, step);
  }

  @override
  int get hashCode {
    List<int?> h = [start, stop, step];
    return Object.hashAll(h);
  }
}

class ndarray implements Finalizable {
  Pointer<Void> arrPtr;
  late final ndArrayFlat flat;

  static final NumdBindings xtensorNdArray =
      NumdBindings(NumdDynamicLib().xTensorLib);
  static final _finalizer = NativeFinalizer(xtensorNdArray.delete_xarrayPtr);

  ndarray._(this.arrPtr) {
    flat = ndArrayFlat(this);
    _finalizer.attach(this, Pointer.fromAddress(arrPtr.address));
  }

  factory ndarray.fromPointer(Pointer<Void> arrPtr) {
    final _ndArray = ndarray._(arrPtr);
    return _ndArray;
  }

  factory ndarray.fromShape(List<int> shape, {double filling = 0}) {
    Pointer<Int64> _shape_c = intListToCArray(shape);
    Pointer<Void> arrPtr =
        xtensorNdArray.create_xarray(shape.length, _shape_c, filling);
    calloc.free(_shape_c);
    final _ndArray = ndarray._(arrPtr);
    return _ndArray;
  }

  factory ndarray.fromList(List mylist) {
    List<int> listShape = __getListOfListSize(mylist, []);
    ndarray array = ndarray.fromShape(listShape);

    for (List<int> idx in ShapeIterator(listShape)) {
      dynamic listValue = mylist;
      for (int i in idx) {
        listValue = listValue[i];
      }
      array[idx] = listValue;
    }
    return array;
  }

  static List<int> __getListOfListSize(dynamic mylist, List<int> currentSize) {
    if (mylist is List) {
      currentSize.add(mylist.length);
      return __getListOfListSize(mylist[0], currentSize);
    } else if (mylist is int || mylist is double) {
      return currentSize;
    } else {
      throw "Unrecognized type for construcing an array ${mylist.runtimeType}";
    }
  }

  int get size => xtensorNdArray.get_size(arrPtr);
  int get ndim => xtensorNdArray.get_ndim(arrPtr);

  ndarray get T => ndarray.fromPointer(xtensorNdArray.transpose(arrPtr));

  void reshape(List<int> shape) {
    if (shape.reduce((a, b) => a * b) != size) {
      throw "New shape must be compatible with the original shape";
    }
    Pointer<Int64> _shape_c = intListToCArray(shape);
    xtensorNdArray.reshape(arrPtr, _shape_c, shape.length);
    calloc.free(_shape_c);
  }

  List<int> get shape {
    List<int> _shape = [];
    Pointer<Int64> _shape_c = calloc<Int64>(ndim);
    xtensorNdArray.get_shape(arrPtr, _shape_c);
    for (var i = 0; i < ndim; i++) {
      _shape.add(_shape_c[i]);
    }
    calloc.free(_shape_c);
    return _shape;
  }

  ndarray operator +(dynamic other) {
    if (other is ndarray) {
      return ndarray
          .fromPointer(xtensorNdArray.add_arrays(arrPtr, other.arrPtr));
    } else if (other is int || other is double) {
      return ndarray
          .fromPointer(xtensorNdArray.add_double(arrPtr, other.toDouble()));
    } else {
      throw "Type ${other.runtimeType} is not supported for an addition operation";
    }
  }

  ndarray operator -(dynamic other) {
    if (other is ndarray) {
      return ndarray
          .fromPointer(xtensorNdArray.substract_arrays(arrPtr, other.arrPtr));
    } else if (other is int || other is double) {
      return ndarray.fromPointer(
          xtensorNdArray.substract_double(arrPtr, other.toDouble()));
    } else {
      throw "Type ${other.runtimeType} is not supported for an addition operation";
    }
  }

  ndarray operator *(dynamic other) {
    if (other is ndarray) {
      return ndarray
          .fromPointer(xtensorNdArray.multiply_arrays(arrPtr, other.arrPtr));
    } else if (other is int || other is double) {
      return ndarray.fromPointer(
          xtensorNdArray.multiply_double(arrPtr, other.toDouble()));
    } else {
      throw "Type ${other.runtimeType} is not supported for an addition operation";
    }
  }

  ndarray operator /(dynamic other) {
    if (other is ndarray) {
      return ndarray
          .fromPointer(xtensorNdArray.divide_arrays(arrPtr, other.arrPtr));
    } else if (other is int || other is double) {
      return ndarray
          .fromPointer(xtensorNdArray.divide_double(arrPtr, other.toDouble()));
    } else {
      throw "Type ${other.runtimeType} is not supported for an addition operation";
    }
  }

  dynamic operator [](dynamic idx) {
    var (c_slice_list, nSlices) = idx_to_slices(idx);

    ndarray arr = ndarray
        .fromPointer(xtensorNdArray.slice_array(arrPtr, c_slice_list, nSlices));
    calloc.free(c_slice_list);

    if (arr.size == 1) {
      return arr.flat[0];
    }
    return arr;
  }

  void operator []=(dynamic idx, dynamic other) {
    var (c_slice_list, nSlices) = idx_to_slices(idx);

    if (other is ndarray) {
      xtensorNdArray.assign_array_to_slice(
          arrPtr, other.arrPtr, c_slice_list, nSlices);
    } else if (other is int || other is double) {
      xtensorNdArray.assign_double_to_slice(
          arrPtr, other.toDouble(), c_slice_list, nSlices);
    } else {
      throw "Type ${other.runtimeType} is not supported for an addition operation";
    }

    calloc.free(c_slice_list);
  }

  @override
  bool operator ==(Object other) {
    if (other is ndarray) {
      if (!ListEquality().equals(shape, other.shape)) return false;

      for (int i in Range(size)) {
        if (flat[i] != other.flat[i]) return false;
      }
      return true;
    }
    return false;
  }

  Float64List asTypedList() {
    Float64List reducedData = Float64List(size);
    for (int i in Range(size)) {
      reducedData[i] = flat[i];
    }
    return reducedData;
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(asTypedList()), Object.hashAll(shape));

  (Pointer<slice>, int) idx_to_slices(idx) {
    if (idx is! List) {
      idx = [idx];
    }

    Pointer<slice> c_slice_list = calloc<slice>(idx.length);
    for (var i = 0; i < idx.length; i++) {
      if (idx[i] is int) {
        c_slice_list[i].start = idx[i];
        c_slice_list[i].stop = idx[i];
        c_slice_list[i].step = 1;
        c_slice_list[i].singleValue = true;
      } else if (idx[i] is Slice) {
        Slice currentSlice = idx[i].getFormattedSlice(shape[i]);
        c_slice_list[i].start = currentSlice.start;
        c_slice_list[i].stop = currentSlice.stop!;
        c_slice_list[i].step = currentSlice.step;
        c_slice_list[i].singleValue = false;
      }
    }
    return (c_slice_list, idx.length);
  }

  // TODO get chars from c api.
  @override
  String toString() {
    xtensorNdArray.print_array(arrPtr);
    return "";
  }
}

Pointer<Int64> intListToCArray(List<int> arr) {
  Pointer<Int64> _shape_c = calloc<Int64>(arr.length);
  for (int i = 0; i < arr.length; i++) {
    _shape_c[i] = arr[i];
  }
  return _shape_c;
}
