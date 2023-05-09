import 'views.dart';

class ViewMgrFlat extends ViewMgr {
  late ViewItem viewItemFlat;
  List<int> activeAxesFlat = [];

  ViewMgrFlat.from(ViewMgr old) : super.from(old) {
    if (old is ViewMgrFlat) {
      viewItemFlat = ViewItem.from(old.viewItemFlat);
    } else {
      viewItemFlat = ViewItem(old.size, 1);
    }
    activeAxesFlat.add(0);
  }

  @override
  List<int> get shape => [viewItemFlat.size];

  @override
  Iterator get iterator => ViewMgrFlatIterator(this);

  @override
  int getIndex() {
    // TODO find a better way of doing this .. this is not clean.
    if (activeAxesFlat.isEmpty) {
      int target = viewItemFlat.start;
      List<int> accessCoordinate = [];
      List<int> blocksize = [];
      int block = 1;
      for (int i = super.activeAxes.length - 1; i >= 0; i--) {
        blocksize.add(block);
        block *= viewItems[super.activeAxes[i]].size;
      }
      blocksize = List.from(blocksize.reversed);

      for (int i = 0; i < super.activeAxes.length; i++) {
        int variable = target - (target) % blocksize[i];
        accessCoordinate.add(variable ~/ blocksize[i]);
        target -= variable;
      }

      int index = 0;
      for (int i = 0; i < super.viewItems.length; i++) {
        if (super.activeAxes.contains(i)) {
          int idx = super.activeAxes.singleWhere((element) => element == i);
          index += accessCoordinate[idx] *
              super.viewItems[super.activeAxes[i]].blockSize;
          index += super.viewItems[super.activeAxes[i]].start *
              super.viewItems[super.activeAxes[i]].blockSize;
        } else {
          index += super.viewItems[i].start * super.viewItems[i].blockSize;
        }
      }

      return index;
    }
    throw "Cannot access Index of view with a size greater than 1";
  }

  @override
  void sliceView(dynamic idx, int axis) {
    viewItemFlat.setRange(idx);
    if (viewItemFlat.size == 1) activeAxesFlat.removeAt(axis);
  }

  @override
  String toString() {
    return "Contents of view:\n\n + $viewItemFlat";
  }
}

class ViewMgrFlatIterator implements Iterator {
  ViewMgr viewMgr;

  int indexOffset = 0;

  List<int> currentAxisIdx = [];
  List<int> axisSizes = [];
  List<int> blockSizes = [];

  ViewMgrFlatIterator(this.viewMgr) {
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
    int currentIdx = indexOffset;
    for (int i = 0; i < viewMgr.activeAxes.length; i++) {
      currentIdx += currentAxisIdx[i] * blockSizes[i];
    }
    return viewMgr.data[currentIdx];
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
