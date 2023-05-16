import 'package:numd/numd.dart' as nd;

void main(List<String> args) {
  var a = nd.ones([10, 10]);
  var b = a[0];
  print(b[0]);
  print(b.view);
  print(b.flat[0]);
  print(nd.max(b));
}
