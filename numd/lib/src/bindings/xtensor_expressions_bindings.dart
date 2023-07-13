import 'package:numd/src/bindings/xtensor_bindings.dart';

import 'dart:ffi';

final class histogram_pointers extends Struct {
  external Pointer<Void> count;
  external Pointer<Void> bin_edges;
}

typedef Mean_c = Pointer<Void> Function(
    Pointer<Void>, Pointer<Int64> axis, Int64 n_axes);
typedef Mean = Pointer<Void> Function(
    Pointer<Void>, Pointer<Int64> axis, int n_axes);

typedef Min_c = Pointer<Void> Function(
    Pointer<Void>, Pointer<Int64> axis, Int64 n_axes);
typedef Min = Pointer<Void> Function(
    Pointer<Void>, Pointer<Int64> axis, int n_axes);

typedef Max_c = Pointer<Void> Function(
    Pointer<Void>, Pointer<Int64> axis, Int64 n_axes);
typedef Max = Pointer<Void> Function(
    Pointer<Void>, Pointer<Int64> axis, int n_axes);

typedef Normalize_c = Pointer<Void> Function(Pointer<Void>);
typedef Normalize = Pointer<Void> Function(Pointer<Void>);

typedef Histogram_c = histogram_pointers Function(Pointer<Void>, Int64 nbins);
typedef Histogram = histogram_pointers Function(Pointer<Void>, int nbins);

typedef rfft_c = Pointer<Void> Function(Pointer<Void>);
typedef rfft = Pointer<Void> Function(Pointer<Void>);

typedef rfft2_c = Pointer<Void> Function(Pointer<Void>);
typedef rfft2 = Pointer<Void> Function(Pointer<Void>);

typedef rfftfreq_c = Pointer<Void> Function(Int64 n, Double d);
typedef rfftfreq = Pointer<Void> Function(int n, double d);

class XtensorExpressions {
  static final XtensorExpressions __instance = XtensorExpressions.__new__();

  late final Mean mean;
  late final Min min;
  late final Max max;
  late final Normalize normalize;

  late final Histogram histogram;

  late final rfft rFFT;
  late final rfft2 rFFT2;
  late final rfftfreq rFFTfreq;

  factory XtensorExpressions() {
    return __instance;
  }

  XtensorExpressions.__new__() {
    final DynamicLibrary xTensorLib = XtensorBindings().xTensorLib;

    mean = xTensorLib.lookup<NativeFunction<Mean_c>>("mean").asFunction();
    min = xTensorLib.lookup<NativeFunction<Min_c>>("min").asFunction();
    max = xTensorLib.lookup<NativeFunction<Max_c>>("max").asFunction();

    normalize = xTensorLib
        .lookup<NativeFunction<Normalize_c>>("normalize")
        .asFunction();

    histogram = xTensorLib
        .lookup<NativeFunction<Histogram_c>>("histogram")
        .asFunction();

    rFFT = xTensorLib.lookup<NativeFunction<rfft_c>>("rfft").asFunction();
    rFFT2 = xTensorLib.lookup<NativeFunction<rfft2_c>>("rfft2").asFunction();
    rFFTfreq =
        xTensorLib.lookup<NativeFunction<rfftfreq_c>>("rfftfreq").asFunction();
  }
}
