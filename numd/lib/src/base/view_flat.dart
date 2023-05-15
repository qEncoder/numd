import 'package:numd/src/base/view.dart';

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
  Iterable get indexIterator => ViewMgrFlatIndexIterable(this);

  @override
  int getFlatIndex(List<int> idxList) {
    if (idxList.isNotEmpty) {
      throw "raise notImplemented Error";
    }
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

class ViewMgrFlatIterator extends ViewMgrFlatIndexIterator {
  ViewMgrFlatIterator(super.viewMgr);

  @override
  get current {
    return viewMgr.data[super.current];
  }
}

class ViewMgrFlatIndexIterable extends Iterable {
  ViewMgr viewMgr;
  ViewMgrFlatIndexIterable(this.viewMgr);

  @override
  Iterator get iterator => ViewMgrFlatIndexIterator(viewMgr);
}

class ViewMgrFlatIndexIterator extends ViewMgrIndexIterator {
  ViewMgrFlatIndexIterator(super.viewMgr);

  @override
  get current {
    int currentIdx = indexOffset;
    for (int i = 0; i < viewMgr.activeAxes.length; i++) {
      currentIdx += currentAxisIdx[i] * blockSizes[i];
    }
    return currentIdx;
  }
}
