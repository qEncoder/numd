import 'dart:typed_data';
import 'views.dart';
import 'view_flat.dart';

class ndarray extends Iterable {
  late final Float64List data;
  late final ViewMgr view;

  ndarray(List<int> shape) {
    data = Float64List(shape.reduce((value, element) => value * element));
    view = ViewMgr(data, shape);
  }

  ndarray.rawConstructor(this.data, this.view);

  ndarray.from(ndarray old) {
    data = old.data;
    if (old.view is ViewMgrFlat) {
      view = ViewMgrFlat.from(old.view);
    } else {
      view = ViewMgr.from(old.view);
    }
  }

  List<int> get shape => view.shape;

  int get size => view.shape.reduce((value, element) => value * element);

  int get ndim => view.shape.length;

  ndarray get T => ndarray.rawConstructor(data, view.tranposeView());

  dynamic operator [](dynamic idx) {
    ndarray newArray = ndarray.from(this);
    if (idx is List) {
      for (int i = idx.length - 1; i >= 0; i--) {
        newArray.view.sliceView(idx[i], i);
      }
    } else {
      newArray.view.sliceView(idx, 0);
    }

    if (newArray.size == 1) {
      return newArray.data[newArray.view.getIndex()];
    }
    return newArray;
  }

  @override
  Iterator get iterator => ViewMgrIterator(view);

  ndarray get flat => ndarray.rawConstructor(data, ViewMgrFlat.from(view));

  // @override
  // String toString() {
  //   // if ndim == 0:

  //   return "output";
  // }

  // void operator []=(dynamic index, dynamic value) {
  //   data[index] = value;
  // }
}

// // array.empty(Record shape) {}
// // array.full(Record shape, double fillValue) {}
// // array.from() {}

// // ndarray zeros(List<int> shape) {
// //   var arr = ndarray(shape);
// //   shape = 0;
// // }

// // ndarray ones(Record shape) {
// //   return ndarray();
// // }

// // ndarray eye(n) {
// //   return ndarray();
// // }

void main(List<String> args) {
  var a = ndarray([2, 3, 5]);

  var c = a[[Slice(0, -1), Slice(0, -1), Slice(1, 4)]];
  // // print(c.)
  // print(c.shape);
  var d = c.flat;
  // print(d.view);
  // print(c.shape);
  // print(d[0]);
  // print(d[1]);
  // print(d[2]);
  // print(d[3]);
  // print(d[4]);
  for (var i in c[0]) {
    print(i.view);
  }
}
