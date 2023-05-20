# Numerical Dart (numd)

This is a library that brings a numpy alike functionality to Dart/Flutter.

Currently the following features as supported: 
* n-dimensional arrays with support for slicing.
* Addition, multiplication, subtraction, divisions.
* Averaging, normalize, min, max.

## Examples

Creating of array can be done with similar commands as in numpy, `empty`,`zeros`, `ones`, `linspace`, `eye`. For example : 
```
import 'package:numd/numd.dart' as nd;

List<int> shape = [10,10];
ndarray myArray = nd.ones(shape);
```
Slicing just works as in numpy (negative indexes are also supported):
```
var slicedArray = myArray[Slice(0, 5)];
// for multiple slices, a list of slices/integers has to be given
var otherSlicedArray = myArray[[2, Slice(0, 5)]];
```
Multiplication works as expected (similarly as the other operations)
```
ndarray myArray1 = nd.ones([5,5]);
ndarray myArray2 = nd.linpace(0,4,5);

var result1 = myArray1*5;
var result2 = myArray1*myArray2;
var result3 = myArray1*myArray1;
```