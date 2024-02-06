class Range extends Iterable {
  int nValues;
  Range(this.nValues);

  @override
  Iterator get iterator => RangeIterator(0, nValues, 1);
}

class RRange extends Iterable {
  int start;
  int stop;
  RRange(this.start, this.stop);

  @override
  Iterator get iterator => RangeIterator(start, stop, 1);
}

class RangeIterator implements Iterator {
  int start;
  int stop;
  int step;
  RangeIterator(this.start, this.stop, this.step) {
    start -= step;
  }

  @override
  int get current => start;

  @override
  bool moveNext() {
    start++;
    if (start == stop) {
      return false;
    }
    return true;
  }
}

class ShapeIterator extends Iterable {
  final List<int> shape;
  ShapeIterator(this.shape);

  @override
  Iterator get iterator => _ShapeIterator(shape);
}

class _ShapeIterator implements Iterator {
  final List<int> shape;
  List<int> currentShape;

  _ShapeIterator(List<int> shape)
      : shape = List.from(shape.reversed),
        currentShape = List<int>.generate(shape.length, (index) => 0) {
    currentShape[0] = -1;
  }

  @override
  get current {
    return List<int>.from(currentShape.reversed);
  }

  @override
  bool moveNext() {
    bool reset = false;
    for (var i = 0; i < shape.length; i++) {
      if (currentShape[i] + 1 < shape[i]) {
        currentShape[i] += 1;
        if (reset) {
          for (var j = i - 1; j >= 0; j--) {
            currentShape[j] = 0;
          }
        }
        return true;
      } else {
        reset = true;
      }
    }
    return false;
  }
}
