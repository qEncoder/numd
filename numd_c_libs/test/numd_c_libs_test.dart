import 'package:flutter_test/flutter_test.dart';
import 'package:numd_c_libs/numd_c_libs.dart';
import 'package:numd_c_libs/numd_c_libs_platform_interface.dart';
import 'package:numd_c_libs/numd_c_libs_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNumdCLibsPlatform
    with MockPlatformInterfaceMixin
    implements NumdCLibsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NumdCLibsPlatform initialPlatform = NumdCLibsPlatform.instance;

  test('$MethodChannelNumdCLibs is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNumdCLibs>());
  });

  test('getPlatformVersion', () async {
    NumdCLibs numdCLibsPlugin = NumdCLibs();
    MockNumdCLibsPlatform fakePlatform = MockNumdCLibsPlatform();
    NumdCLibsPlatform.instance = fakePlatform;

    expect(await numdCLibsPlugin.getPlatformVersion(), '42');
  });
}
