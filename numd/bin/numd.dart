import 'package:numd/numd.dart' as nd;
import 'package:numd/src/base/ndarray.dart';

nd.ndarray get2Darray() {
  return nd.ndarray.fromList([
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0]
  ]);
}

void main(List<String> args) {
  // var a = nd.ones([10]);
  // print(a[0]);
  var a = ndarray.fromShape([100, 100], 0);
  // var b = get2Darray();
  // var c = nd.ndarray.fromList([1.0, 2.0, 3.0]);
  // print(b[0]);
  // print(c);

  // print("error before");
  // nd.ndarray a = get2Darray()[0];
  // nd.ndarray b = nd.ndarray.fromList([1.0, 2.0, 4.0, 3.0]);
  // print("error after");
  // print(a);
  // print(b);
  // print(a.hashCode);
  // print(b.hashCode);
  // print(a == b);
  // expect(true, a == b);

  // print(b[0]);
  // var a = nd.ndarray.fromList([
  //   [1, 5, 8],
  //   [1, 5, 8]
  // ]);
  // print(a);
}
