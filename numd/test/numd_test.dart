import 'package:numd/numd.dart';
import 'package:test/test.dart';

void main() {
  ndarray get1Darray() {
    return ndarray.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
  }

  ndarray get2Darray() {
    return ndarray.fromList([
      [1.0, 2.0, 3.0],
      [4.0, 5.0, 6.0]
    ]);
  }

  ndarray get3Darray() {
    return ndarray.fromList([
      [
        [1, 1, 1, 1],
        [2, 2, 2, 2],
        [3, 3, 3, 3]
      ],
      [
        [4, 4, 4, 4],
        [5, 5, 5, 5],
        [6, 6, 6, 6]
      ]
    ]);
  }

  group("ndarray List assignment tests", () {
    test('List 1D (1,)', () {
      ndarray a = ndarray.fromList([1.0]);
      expect(a.shape, [1]);
    });

    test('List 1D<int> (5,)', () {
      ndarray a = ndarray.fromList([1, 2, 3, 4, 5]);
      expect(a.shape, [5]);
    });

    test('List 1D<float> (5,)', () {
      ndarray a = ndarray.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(a.shape, [5]);
    });

    test('List 2D (2,3)', () {
      ndarray a = ndarray.fromList([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0]
      ]);
      expect(a.shape, [2, 3]);
    });

    test('List 3D (2,3,4)', () {
      ndarray a = ndarray.fromList([
        [
          [1, 1, 1, 1],
          [2, 2, 2, 2],
          [3, 3, 3, 3]
        ],
        [
          [4, 4, 4, 4],
          [5, 5, 5, 5],
          [6, 6, 6, 6]
        ]
      ]);
      expect(a.shape, [2, 3, 4]);
    });
  });

  group("ndarray access element tests", () {
    test('get an element in a 1D array', () {
      ndarray a = ones([3]);
      expect(a[1], 1.0);
    });

    test('get an slice in a 2D array (first axis)', () {
      ndarray a = get2Darray()[0];
      expect(a, ndarray.fromList([1.0, 2.0, 3.0]));
    });

    test('get an slice in a 2D array (second axis)', () {
      ndarray a = get2Darray()[[Slice(0, -1), 0]];
      expect(a, ndarray.fromList([1.0, 4.0]));
    });

    test('get an slice in a 3D array (first axis)', () {
      ndarray a = get3Darray()[0];
      expect(
          a,
          ndarray.fromList(
            [
              [1, 1, 1, 1],
              [2, 2, 2, 2],
              [3, 3, 3, 3]
            ],
          ));
    });

    test('get an slice in a 3D array (second axis)', () {
      ndarray a = get3Darray()[[Slice(0, -1), 0]];
      expect(
          a,
          ndarray.fromList([
            [1, 1, 1, 1],
            [4, 4, 4, 4],
          ]));
    });

    test('get an slice in a 3D array (third axis)', () {
      ndarray a = get3Darray()[[Slice(0, -1), Slice(0, -1), 0]];
      expect(
          a,
          ndarray.fromList([
            [1, 2, 3],
            [4, 5, 6]
          ]));
    });

    test('get an slice in a 3D array (two in parallel)', () {
      ndarray a = get3Darray()[[Slice(0, -1), 0, 0]];
      expect(a, ndarray.fromList([1, 4]));
    });

    test('get sub-array from 1D array', () {
      ndarray a = get1Darray()[Slice(1, 4)];
      expect(a, ndarray.fromList([2, 3, 4]));
    });

    test('get sub-array from 2D array (both axes)', () {
      ndarray a = get2Darray()[[Slice(1, 2), Slice(1, 3)]];
      expect(
          a,
          ndarray.fromList([
            [5, 6]
          ]));
    });
  });

  group("ndarray assignement test", () {
    test('Assign single element to 1D array', () {
      ndarray a = get1Darray();
      a[1] = 8;
      a[Slice(3, 5)] = 8;
      expect(a, ndarray.fromList([1.0, 8.0, 3.0, 8.0, 8.0, 6.0]));
    });

    test('Assign single elements to 2D array', () {
      ndarray a = get2Darray();
      a[[0, 2]] = 8;
      a[[1, 1]] = 7;
      expect(
          a,
          ndarray.fromList([
            [1.0, 2.0, 8.0],
            [4.0, 7.0, 6.0]
          ]));
    });

    test('Assign array 1D to a 2D array test 1', () {
      ndarray a = get2Darray();
      a[[Slice(0, -1), 2]] = ndarray.fromList([7, 8]);
      expect(
          a,
          ndarray.fromList([
            [1.0, 2.0, 7.0],
            [4.0, 5.0, 8.0]
          ]));
    });

    test('Assign array 1D to a 2D array test 2', () {
      ndarray a = get2Darray();
      // current operators do not support a[[:]]
      a[[0]] = ndarray.fromList([7, 8, 9]);
      a[[1]] = ndarray.fromList([7, 8, 9]);
      expect(
          a,
          ndarray.fromList([
            [7.0, 8.0, 9.0],
            [7.0, 8.0, 9.0]
          ]));
    });

    test('Assign a 2D to a 3D array', () {
      ndarray a = get3Darray();
      a[[Slice(0, -1), Slice(0, 2), 0]] = ndarray.fromList([
        [
          7,
          8,
        ],
        [9, 10]
      ]);
      expect(
          a,
          ndarray.fromList([
            [
              [7, 1, 1, 1],
              [8, 2, 2, 2],
              [3, 3, 3, 3]
            ],
            [
              [9, 4, 4, 4],
              [10, 5, 5, 5],
              [6, 6, 6, 6]
            ]
          ]));
    });
  });

  group("averaging arrays", () {
    ndarray arrayToAverage = ndarray.fromList([
      [
        [1, 2, 3, 4, 5],
        [6, 7, 8, 9, 10]
      ],
      [
        [11, 12, 13, 14, 15],
        [16, 17, 18, 19, 20]
      ],
      [
        [21, 22, 23, 24, 25],
        [26, 27, 28, 29, 30]
      ]
    ]);

    test("simple average", () {
      double avg = average(arrayToAverage);
      expect(avg, 15.5);
    });
    test("average along diff directions (1D), test 1", () {
      ndarray avg = average(arrayToAverage, axis: 0);
      expect(
          avg,
          ndarray.fromList([
            [11, 12, 13, 14, 15],
            [16, 17, 18, 19, 20]
          ]));
    });

    test("average along diff directions (1D), test 2", () {
      ndarray avg = average(arrayToAverage, axis: 1);
      expect(
          avg,
          ndarray.fromList([
            [3.5, 4.5, 5.5, 6.5, 7.5],
            [13.5, 14.5, 15.5, 16.5, 17.5],
            [23.5, 24.5, 25.5, 26.5, 27.5]
          ]));
    });

    test("average along diff directions (2D), test 1", () {
      ndarray avg = average(arrayToAverage, axis: [0, 1]);
      expect(avg, ndarray.fromList([13.5, 14.5, 15.5, 16.5, 17.5]));
    });

    test("average along diff directions (2D), test 1", () {
      ndarray avg = average(arrayToAverage, axis: [0, 2]);
      expect(avg, ndarray.fromList([13, 18]));
    });
  });
}
