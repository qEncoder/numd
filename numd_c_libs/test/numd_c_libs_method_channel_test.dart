import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numd_c_libs/numd_c_libs_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNumdCLibs platform = MethodChannelNumdCLibs();
  const MethodChannel channel = MethodChannel('numd_c_libs');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
