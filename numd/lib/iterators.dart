class Range extends Iterable {
  int nValues;
  Range(this.nValues);

  @override
  Iterator get iterator => RangeIterator(0, nValues, 1);
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
