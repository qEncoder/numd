import 'package:numd/src/base/ndarray.dart';
import 'package:numd/src/utility/iterators.dart';

import 'dart:typed_data';

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
      start = _getIdx(idx, false);
      stop = start + 1;
    } else if (idx is Slice) {
      stop = _getIdx(idx.stop, true);
      start = _getIdx(idx.start, false);
    } else {
      throw "Faulty type to access an index.";
    }
  }

  int _getIdx(int idx, bool end) {
    if (idx >= 0) {
      idx += start;
      int offset = end ? 1 : 0;
      if (idx >= stop + offset)
        throw "RangeError : index ${idx - start} is out for bound (allowed values :[0 -> ${size - 1}]).";
    } else {
      idx = stop + idx + 1;
      if (idx < start)
        throw "RangeError : index  ${idx - stop - 1} is out for bound (allowed values :[${-size} -> -1]).";
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

class ViewMgrIndexIterable extends Iterable {
  ViewMgr viewMgr;
  ViewMgrIndexIterable(this.viewMgr);

  @override
  Iterator get iterator => ViewMgrIndexIterator(viewMgr);
}

class ViewMgrIndexIterator implements Iterator {
  ViewMgr viewMgr;

  int indexOffset = 0;
  List<int> currentAxisIdx = [];
  List<int> axisSizes = [];
  List<int> blockSizes = [];

  ViewMgrIndexIterator(this.viewMgr) {
    for (var viewItem in viewMgr.viewItems) {
      indexOffset += viewItem.blockSize * viewItem.start;
    }
    for (int axis in viewMgr.activeAxes) {
      blockSizes.add(viewMgr.viewItems[axis].blockSize);
      axisSizes.add(viewMgr.viewItems[axis].size);
      currentAxisIdx.add(0);
    }
    currentAxisIdx[axisSizes.length - 1] = -1;
  }

  @override
  get current {
    return currentAxisIdx;
  }

  @override
  bool moveNext() {
    for (int i = currentAxisIdx.length - 1; i >= 0; i--) {
      if (currentAxisIdx[i] != axisSizes[i] - 1) {
        currentAxisIdx[i] += 1;

        for (int j = i + 1; j < currentAxisIdx.length; j++) {
          currentAxisIdx[j] = 0;
        }
        return true;
      }
    }
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
    if (idxList.isNotEmpty) {
      if (activeAxes.length != idxList.length) {
        throw "Cannot access Index $idxList of an array with shape $shape";
      }
    } else {
      idxList = List.filled(activeAxes.length, 0);
    }
    int idx = 0;
    for (int i in Range(activeAxes.length)) {
      idx += viewItems[activeAxes[i]].index(offset: idxList[i]);
    }
    for (int i in Range(viewItems.length)) {
      if (!activeAxes.contains(i)) idx += viewItems[i].index();
    }

    return idx;
  }

  void sliceView(dynamic idx, int axis) {
    viewItems[activeAxes[axis]].setRange(idx);
    if (idx is int) activeAxes.removeAt(axis);
  }

  @override
  Iterator get iterator => ViewMgrIterator(this);
  Iterable get indexIterator => ViewMgrIndexIterable(this);

  @override
  String toString() {
    String output = "Contents of view:\n\n";
    for (var i in viewItems) {
      output += i.toString();
    }
    return output;
  }
}
