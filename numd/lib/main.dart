import 'package:flutter/material.dart';
import 'package:numd/numd.dart' as nd;
import 'package:numd/src/base/ndarray.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late nd.ndarray sumResult;
  late double average;
  // late Future<int> sumAsyncResult;

  @override
  void initState() {
    super.initState();
    sumResult = nd.ndarray.fromList([10, 2, 20, double.nan]);
    // sumResult = numd.linspace(0, 100, 20);
    print(nd.arange(10)[Slice(0)]);
    print(nd.arange(10));
    // print(sumResult[0]);
    // print(sumResult[1]);
    // print(sumResult[2]);
    // sumResult..reshape([2,2]);
    // print(sumResult);
    // sumResult = nd.swapaxes(sumResult, 0, 1);
    // print(sumResult);
    // sumResult = nd.flip(sumResult, 0);
    // print(sumResult);
    // sumResult.reshape([4]);
    
    // print(nd.rFFT(sumResult));
    // print(nd.mean(sumResult));
    // average = nd.nanmax(sumResult);
    // print(average);
    // for (final i in nd.RRange(0, 10)) {
    //   print(i);
    // }
    // print(sumResult.asTypedList());
    // sumAsyncResult = numd.sumAsync(3, 4);
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'sum(1, 2) = ${sumResult[0]}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
