
import 'numd_c_libs_platform_interface.dart';

class NumdCLibs {
  Future<String?> getPlatformVersion() {
    return NumdCLibsPlatform.instance.getPlatformVersion();
  }
}
