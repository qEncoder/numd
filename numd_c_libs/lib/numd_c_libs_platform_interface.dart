import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'numd_c_libs_method_channel.dart';

abstract class NumdCLibsPlatform extends PlatformInterface {
  /// Constructs a NumdCLibsPlatform.
  NumdCLibsPlatform() : super(token: _token);

  static final Object _token = Object();

  static NumdCLibsPlatform _instance = MethodChannelNumdCLibs();

  /// The default instance of [NumdCLibsPlatform] to use.
  ///
  /// Defaults to [MethodChannelNumdCLibs].
  static NumdCLibsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NumdCLibsPlatform] when
  /// they register themselves.
  static set instance(NumdCLibsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
