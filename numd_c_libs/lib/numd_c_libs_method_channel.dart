import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'numd_c_libs_platform_interface.dart';

/// An implementation of [NumdCLibsPlatform] that uses method channels.
class MethodChannelNumdCLibs extends NumdCLibsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('numd_c_libs');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
