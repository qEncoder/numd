bool isClose(double a, double b, {double relTol = 1e-9, double absTol = 0}){
  if (relTol < 0 || absTol < 0){
    throw ArgumentError('tolerances must be non-negative');
  }
  return (((a-b)/a).abs() < relTol) | ((a-b).abs() < absTol) ;
}
