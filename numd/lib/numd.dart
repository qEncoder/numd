import 'package:collection/collection.dart';

import 'dart:typed_data';
import 'views.dart';
import 'view_flat.dart';
import 'iterators.dart';

class ndarray extends Iterable {
  // TODO implement print option
  late final Float64List data;
  late final ViewMgr view;

  ndarray(List<int> shape) {
    data = Float64List(shape.reduce((value, element) => value * element));
    view = ViewMgr(data, shape);
  }

  ndarray.rawConstructor(Float64List mydata, ViewMgr myview) {
    if (myview.data.length != mydata.length)
      throw "The size of the view does not correspond to the size of the array.";
    data = mydata;
    view = myview..data = mydata;
  }

  ndarray.from(ndarray old) {
    data = old.data;
    if (old.view is ViewMgrFlat) {
      view = ViewMgrFlat.from(old.view);
    } else {
      view = ViewMgr.from(old.view);
    }
  }

  // TODO extend to lists of any dimension
  ndarray.fromList(List mylist) {
    data = Float64List(mylist.length);
    for (int i = 0; i < mylist.length; i++) {
      data[i] = mylist[i] as double;
    }
    view = ViewMgr(data, [mylist.length]);
  }

  List<int> get shape => view.shape;
  int get size => _getSize();
  int get ndim => view.shape.length;

  @override
  Iterator get iterator => ViewMgrIterator(view);
  ndarray get flat => ndarray.rawConstructor(data, ViewMgrFlat.from(view));
  ndarray get T => ndarray.rawConstructor(data, view.tranposeView());

  int _getSize() {
    int s = 1;
    for (var e in shape) {
      s *= e;
    }
    return s;
  }

  dynamic operator [](dynamic idx) {
    ndarray newArray = ndarray.from(this);
    if (idx is List) {
      for (int i = idx.length - 1; i >= 0; i--) {
        newArray.view.sliceView(idx[i], i);
      }
    } else if (idx is int) {
      newArray.view.sliceView(idx, 0);
    } else {
      throw "Type for index invalid (${idx.runtimeType})";
    }

    if (newArray.size == 1) {
      return newArray.data[newArray.view.getFlatIndex([])];
    }
    return newArray;
  }

  void operator []=(dynamic index, dynamic other) {
    if (other is int || other is double) {
      if (index is List<int>) {
        if (ndim == index.length) {
          data[view.getFlatIndex(index)] = other as double;
          return;
        }
      }
      if (index is int && ndim == 1) {
        data[view.getFlatIndex([index])] = other.toDouble();
        return;
      }

      var arrSliced = ndarray.from(this)[index];

      if (arrSliced.size == 1) {
        arrSliced[arrSliced.view.getFlatIndex([])] = other.toDouble();
      } else {
        for (int i in arrSliced.flat.view.indexIterator) {
          arrSliced.data[i] = other.toDouble();
        }
      }
    } else {
      if (other is List) {
        other = ndarray.fromList(other);
      }
      if (other is ndarray) {
        ndarray arrSliced = ndarray.from(this)[index];
        if (other.ndim < arrSliced.ndim) {
          if (other.shape[0] == shape[1]) {
            for (ndarray a in arrSliced) {
              a[Slice(0, -1)] = other;
            }
          } else {
            throw "Cannot assign two ndarrays of different shapes (current : ${arrSliced.shape}, other : ${other.shape})";
          }
        } else if (other.ndim == arrSliced.ndim) {
          if (!ListEquality().equals(other.shape, arrSliced.shape)) {
            throw "Cannot assign two ndarrays of different shapes (current : ${arrSliced.shape}, other : ${other.shape})";
          }
          for (final idxVal in IterableZip(
              [arrSliced.flat.view.indexIterator, other.flat.view])) {
            arrSliced.data[idxVal[0]] = idxVal[1];
          }
        } else {
          throw "Cannot assign and ndarrays with the shape ${other.shape} to ${arrSliced.shape}";
        }
      } else {
        throw "Cannot asssign an ndarray to the type ${other.hashCode}";
      }
    }
  }

  ndarray operator *(dynamic other) {
    ndarray result = ndarray(shape);
    if (other is int || other is double) {
      for (final idxVal
          in IterableZip([result.flat.view.indexIterator, flat.view])) {
        result.data[idxVal[0]] = idxVal[1] * other.toDouble();
      }
    } else if (other is ndarray) {
      if (ListEquality().equals(other.shape, result.shape)) {
        for (final idxVal in IterableZip(
            [result.flat.view.indexIterator, flat.view, other.flat.view])) {
          result.data[idxVal[0]] = idxVal[1] * idxVal[2];
        }
      } else if (other.ndim < result.ndim) {
        for (final idxVal in IterableZip([result, flat])) {
          idxVal[0][Slice(0, -1)] = idxVal[1] * other;
        }
      } else {
        throw "Cannot multiply an object with shape $shape and ${other.shape}";
      }
    }
    return result;
  }

  ndarray operator /(dynamic other) {
    if (other is int || other is double) {
      return this * (1 / other);
    } else if (other is ndarray) {
      ndarray result = ndarray(shape);
      if (ListEquality().equals(other.shape, result.shape)) {
        for (final idxVal in IterableZip(
            [result.flat.view.indexIterator, flat.view, other.flat.view])) {
          result.data[idxVal[0]] = idxVal[1] / idxVal[2];
        }
      } else if (other.ndim < result.ndim) {
        for (final idxVal in IterableZip([result, flat])) {
          idxVal[0][Slice(0, -1)] = idxVal[1] / other;
        }
      } else {
        throw "Cannot multiply an object with shape $shape and ${other.shape}";
      }
      return result;
    } else {
      throw "invalid datatype (${other.runtimeType})";
    }
  }

  ndarray operator +(dynamic other) {
    ndarray result = ndarray(shape);
    if (other is int || other is double) {
      for (final idxVal
          in IterableZip([result.flat.view.indexIterator, flat.view])) {
        result.data[idxVal[0]] = idxVal[1] + other.toDouble();
      }
      return result;
    } else if (other is ndarray) {
      ndarray result = ndarray(shape);
      if (ListEquality().equals(other.shape, result.shape)) {
        for (final idxVal in IterableZip(
            [result.flat.view.indexIterator, flat.view, other.flat.view])) {
          result.data[idxVal[0]] = idxVal[1] + idxVal[2];
        }
      } else if (other.ndim < result.ndim) {
        for (final idxVal in IterableZip([result, flat])) {
          idxVal[0][Slice(0, -1)] = idxVal[1] + other;
        }
      } else {
        throw "Cannot multiply an object with shape $shape and ${other.shape}";
      }
      return result;
    } else {
      throw "invalid datatype (${other.runtimeType})";
    }
  }

  ndarray operator -(dynamic other) {
    ndarray result = ndarray(shape);
    if (other is int || other is double) {
      for (final idxVal
          in IterableZip([result.flat.view.indexIterator, flat.view])) {
        result.data[idxVal[0]] = idxVal[1] - other.toDouble();
      }
      return result;
    } else if (other is ndarray) {
      ndarray result = ndarray(shape);
      if (ListEquality().equals(other.shape, result.shape)) {
        for (final idxVal in IterableZip(
            [result.flat.view.indexIterator, flat.view, other.flat.view])) {
          result.data[idxVal[0]] = idxVal[1] - idxVal[2];
        }
      } else if (other.ndim < result.ndim) {
        for (final idxVal in IterableZip([result, flat])) {
          idxVal[0][Slice(0, -1)] = idxVal[1] - other;
        }
      } else {
        throw "Cannot multiply an object with shape $shape and ${other.shape}";
      }
      return result;
    } else {
      throw "invalid datatype (${other.runtimeType})";
    }
  }
}

ndarray empty(List<int> shape) {
  return ndarray(shape);
}

ndarray zeros(List<int> shape) {
  return ndarray(shape);
}

ndarray ones(List<int> shape) {
  var arr = ndarray(shape);
  arr.flat[Slice(0, -1)] = 1;
  return arr;
}

ndarray linspace(double start, double stop, int n) {
  var arr = ndarray([n]);
  for (int i in Range(n)) {
    arr.data[i] = start + (stop - start) / (n - 1) * i;
  }
  return arr;
}

ndarray eye(n) {
  var arr = zeros([n, n]);
  for (int i in Range(n)) {
    arr[[i, i]] = 1;
  }
  return arr;
}

void main(List<String> args) {
  var a = ones([3, 3]);
  var b = linspace(0, 2, 3);
  // a[2] = b;
  print(a * b);
}
