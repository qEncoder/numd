import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:numd/numd.dart' as nd;

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
    sumResult = nd.ndarray.fromList([1, 2, 3, 4, 8 , 3, 2, 1, double.nan]);
    // sumResult = nd.linspace(0, 5, 6);
  
    print(sumResult);
    print(sumResult[nd.Slice(0, -1, 2)]);
    print(sumResult[nd.Slice(0, -1, 3)]);
    print(sumResult[nd.Slice(0, -1, 4)]);
    // sumResult = nd.linspace(1e-9, 1e-9+1e-12, 100);
    // var res = nd.histogramLinBin(sumResult, 10, 1e-9, 1e-9+1e-12);
    // print(res.$1);
    // print(res.$2);
    // print(generateHistogramCbar(sumResult, 10, 1e-9, 1e-9+1e-12));

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
                FilledButton(onPressed: (){Stopwatch stopwatch = Stopwatch();
                          sumResult = nd.linspace(-1, 9, 1000*1500);
                          int nbins = 100;
                          int n = 10;

                          stopwatch.start();
                          
                          for (int i in nd.Range(n)){
                            var res = nd.histogramLinBin(sumResult, nbins, 0, 8);
                            var out = (res.$1*(1/(nd.max(res.$1) as double))).asTypedList();
                          }
                          stopwatch.stop();
                          print("Time c++: ${stopwatch.elapsedMilliseconds/n} ms");

                          stopwatch.reset();

                          stopwatch.start();
                          for (int i in nd.Range(n)){
                            var res = generateHistogramCbar(sumResult, nbins,0, 8);
                          }
                          stopwatch.stop();
                          print("Time flutter: ${stopwatch.elapsedMilliseconds/n} ms");

                          stopwatch.reset();
                          
                          
                          stopwatch.start();
                          for (int i in nd.Range(n)){
                            var res = nd.histogramLinBin(sumResult, nbins, 0, 8);
                            var out = (res.$1*(1/(nd.max(res.$1) as double))).asTypedList();
                          }
                          stopwatch.stop();
                          print("Time c++ 2: ${stopwatch.elapsedMilliseconds/n} ms");
                          stopwatch.reset();
                          stopwatch.start();
                          for (int i in nd.Range(1)){
                            var res = nd.histogram(sumResult, nbins);
                          }
                          stopwatch.stop();
                          print("Time c++ (original): ${stopwatch.elapsedMilliseconds/1} ms");

                    }, child: Text("Run HIST")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



 Float64List generateHistogramCbar(nd.ndarray data, int nbins, double min, double max, ){
  double multiplier = 1/(max - min)*nbins;

  Float64List histCount = Float64List(nbins);
  for (int i in nd.Range(data.size)){
    double value = ((data.flat[i] - min)*multiplier);
    if (value.isNaN) continue;
    int index = value.toInt();
    if (index < 0) continue;
    if (index >= nbins){
      if (data.flat[i] == max)	histCount[nbins-1] ++;
			continue;
    }
    histCount[index]++;
    // double item = data.flat[i];
    // if (!(item >= min && item <= max)) continue;
    // int index =  ((item - min)*multiplier).toInt();
    // if (index == nbins) index--;
    // histCount[index]++;

  }

  // double maxCount = histCount.reduce((a, b) => (a > b) ? a : b);
  // for (int i in nd.Range(histCount.length)){
  //   histCount[i] = histCount[i]/maxCount;
  // }

  return histCount;
}