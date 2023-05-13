import 'package:numd/numd.dart';

import 'dart:typed_data';
import "iterators.dart";

class Slice {
  int start;
  int stop;
  Slice(this.start, this.stop);
}

class ViewItem {
  late final int nElem;
  late final int blockSize;
  late int start;
  late int stop;

  ViewItem(this.nElem, this.blockSize) {
    start = 0;
    stop = nElem;
  }

  ViewItem.from(ViewItem old) {
    start = old.start;
    stop = old.stop;
    nElem = old.nElem;
    blockSize = old.blockSize;
  }
  int get size => stop - start;

  setRange(dynamic idx) {
    if (idx is int) {
      start = _getIdx(idx);
      stop = start + 1;
    } else if (idx is Slice) {
      stop = _getIdx(idx.stop);
      start = _getIdx(idx.start);
    } else {
      throw "Faulty type to access an index.";
    }
  }

  int _getIdx(int idx) {
    if (idx >= 0) {
      idx += start;
      if (idx > stop)
        throw "RangeError : index  $idx is out for bound (allowed values :[0, $size]).";
    } else {
      idx = stop + idx + 1;
      if (idx < start)
        throw "RangeError : index  ${idx - stop} is out for bound (allowed values :[0, $size]).";
    }
    return idx;
  }

  int index({int offset = 0}) => (start + offset) * blockSize;

  @override
  String toString() {
    return "Start : $start \t|\tStop : $stop \t|\t nElem $nElem \t|\t blockSize $blockSize \t |\n";
  }
}

class ViewMgrIterator implements Iterator {
  ViewMgr viewMgr;
  int currentIdx = -1;
  ViewMgrIterator(this.viewMgr);

  @override
  get current {
    var array = ndarray.rawConstructor(viewMgr.data, ViewMgr.from(viewMgr));
    return array[currentIdx];
  }

  @override
  bool moveNext() {
    currentIdx++;
    if (currentIdx < viewMgr.shape[0]) return true;
    return false;
  }
}

class ViewMgr extends Iterable {
  late Float64List data;
  List<ViewItem> viewItems = [];
  List<int> activeAxes = [];

  ViewMgr(this.data, List<int> shape) {
    int blockSize = 1;
    for (int i = shape.length - 1; i >= 0; i--) {
      viewItems.add(ViewItem(shape[i], blockSize));
      activeAxes.add(i);
      blockSize *= shape[i];
    }
    activeAxes = List.from(activeAxes.reversed);
    viewItems = List.from(viewItems.reversed);
  }

  ViewMgr.from(ViewMgr old) {
    data = old.data;
    for (var e in old.viewItems) {
      viewItems.add(ViewItem.from(e));
    }
    activeAxes = List.from(old.activeAxes);
  }

  List<int> get shape => List.generate(
      activeAxes.length, (idx) => viewItems[activeAxes[idx]].size);
  int get ndim => shape.length;
  int get size => shape.reduce((value, element) => value * element);

  ViewMgr tranposeView() {
    ViewMgr newView = ViewMgr.from(this);
    newView.activeAxes = List.from(newView.activeAxes.reversed);
    return newView;
  }

  int getFlatIndex(List<int> idxList) {
    if (activeAxes.length != idxList.length) {
      throw "Cannot access Index $idxList of an array with shape $shape";
    }
    int idx = 0;
    for (int i in Range(activeAxes.length)) {
      idx += viewItems[activeAxes[i]].index(offset: idxList[i]);
    }
    for (var view in viewItems) {
      if (view.size == 1) idx += view.index();
    }

    return idx;
  }

  void sliceView(dynamic idx, int axis) {
    viewItems[activeAxes[axis]].setRange(idx);
    if (idx is int) activeAxes.removeAt(axis);
  }

  @override
  Iterator get iterator => ViewMgrIterator(this);
  Iterable get indexIterator => throw "Not Implemented Error";

  @override
  String toString() {
    String output = "Contents of view:\n\n";
    for (var i in viewItems) {
      output += i.toString();
    }
    return output;
  }
}
