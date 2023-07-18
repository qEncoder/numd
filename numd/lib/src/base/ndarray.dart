import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:numd/src/base/ndarray_flat.dart';
import 'package:numd/src/bindings/xtensor_ndarray_bindings.dart';

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:numd/src/utility/iterators.dart';

class Slice {
  int start;
  int stop;
  Slice(this.start, this.stop);

  @override
  String toString() {
    return "Slice of array, start : $start | stop : $stop";
  }

  int get size => (stop < 0) ? -1 : stop - start;
}

class ndarray implements Finalizable {
  Pointer<Void> arrPtr;
  late final ndArrayFlat flat;

  static final XtensorNdArray xtensorNdArray = XtensorNdArray();
  static final _finalizer =
      NativeFinalizer(XtensorNdArray().deleteXArrayNative);

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
    print(shape.length);
    Pointer<Void> arrPtr =
        xtensorNdArray.createXArray(shape.length, _shape_c, filling);
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

  int get size => xtensorNdArray.getSize(arrPtr);
  int get ndim => xtensorNdArray.getNDim(arrPtr);

  ndarray get T => ndarray.fromPointer(xtensorNdArray.transpose(arrPtr));

  List<int> get shape {
    List<int> _shape = [];
    Pointer<Int64> _shape_c = calloc<Int64>(ndim);
    xtensorNdArray.getShape(arrPtr, _shape_c);
    for (var i = 0; i < ndim; i++) {
      _shape.add(_shape_c[i]);
    }
    calloc.free(_shape_c);
    return _shape;
  }

  ndarray operator +(dynamic other) {
    if (other is ndarray) {
      return ndarray
          .fromPointer(xtensorNdArray.addArrays(arrPtr, other.arrPtr));
    } else if (other is int || other is double) {
      return ndarray
          .fromPointer(xtensorNdArray.addDouble(arrPtr, other.toDouble()));
    } else {
      throw "Type ${other.runtimeType} is not supported for an addition operation";
    }
  }

  ndarray operator -(dynamic other) {
    if (other is ndarray) {
      return ndarray
          .fromPointer(xtensorNdArray.substractArrays(arrPtr, other.arrPtr));
    } else if (other is int || other is double) {
      return ndarray.fromPointer(
          xtensorNdArray.substractDouble(arrPtr, other.toDouble()));
    } else {
      throw "Type ${other.runtimeType} is not supported for an addition operation";
    }
  }

  ndarray operator *(dynamic other) {
    if (other is ndarray) {
      return ndarray
          .fromPointer(xtensorNdArray.multiplyArrays(arrPtr, other.arrPtr));
    } else if (other is int || other is double) {
      return ndarray
          .fromPointer(xtensorNdArray.multiplyDouble(arrPtr, other.toDouble()));
    } else {
      throw "Type ${other.runtimeType} is not supported for an addition operation";
    }
  }

  ndarray operator /(dynamic other) {
    if (other is ndarray) {
      return ndarray
          .fromPointer(xtensorNdArray.divideArrays(arrPtr, other.arrPtr));
    } else if (other is int || other is double) {
      return ndarray
          .fromPointer(xtensorNdArray.divideDouble(arrPtr, other.toDouble()));
    } else {
      throw "Type ${other.runtimeType} is not supported for an addition operation";
    }
  }

  dynamic operator [](dynamic idx) {
    var (c_slice_list, nSlices) = idx_to_slices(idx);

    ndarray arr = ndarray
        .fromPointer(xtensorNdArray.sliceArray(arrPtr, c_slice_list, nSlices));
    calloc.free(c_slice_list);

    if (arr.size == 1) {
      return arr.flat[0];
    }
    return arr;
  }

  void operator []=(dynamic idx, dynamic other) {
    var (c_slice_list, nSlices) = idx_to_slices(idx);

    if (other is ndarray) {
      xtensorNdArray.assignArrayToSlice(
          arrPtr, other.arrPtr, c_slice_list, nSlices);
    } else if (other is int || other is double) {
      xtensorNdArray.assignDoubleToSlice(
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

  Float64List __getReducedData() {
    Float64List reducedData = Float64List(size);
    for (int i in Range(size)) {
      reducedData[i] = flat[i];
    }
    return reducedData;
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(__getReducedData()), Object.hashAll(shape));

  (Pointer<c_slice>, int) idx_to_slices(idx) {
    if (idx is! List) {
      idx = [idx];
    }

    Pointer<c_slice> c_slice_list = calloc<c_slice>(idx.length);
    for (var i = 0; i < idx.length; i++) {
      if (idx[i] is int) {
        c_slice_list[i].start = idx[i];
        c_slice_list[i].stop = idx[i];
        c_slice_list[i].noRange = true;
      } else if (idx[i] is Slice) {
        c_slice_list[i].start = idx[i].start;
        c_slice_list[i].stop = idx[i].stop;
        c_slice_list[i].noRange = false;
      }
    }
    return (c_slice_list, idx.length);
  }

  // TODO get chars from c api.
  @override
  String toString() {
    xtensorNdArray.printArray(arrPtr);
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
