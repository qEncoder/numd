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
    int target = viewItemFlat.start;
    if (idxList.isNotEmpty) target += idxList[0];

    List<int> nonFlatShape = super.shape;
    List<int> nonFlatIndex = List.from(nonFlatShape);

    for (int i = nonFlatIndex.length - 1; i >= 0; i--) {
      nonFlatIndex[i] = target % nonFlatShape[i];
      target = (target - nonFlatIndex[i]) ~/ nonFlatShape[i];
    }

    return super.getFlatIndex(nonFlatIndex);
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
