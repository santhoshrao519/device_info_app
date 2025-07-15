import 'package:flutter/services.dart';

class DevicePlatformChannel {
  static const _channel = MethodChannel('device_channel');

  Future<int> getBatteryLevel() async {
    try {
      final result = await _channel.invokeMethod<int>('getBatteryLevel');
      return result ?? -1;
    } catch (e) {
      throw Exception('Failed to get battery level: $e');
    }
  }

  Future<String> getDeviceName() async {
    try {
      final result = await _channel.invokeMethod<String>('getDeviceName');
      return result ?? 'Unknown Device';
    } catch (e) {
      throw Exception('Failed to get device name: $e');
    }
  }

  Future<String> getOSVersion() async {
    try {
      final result = await _channel.invokeMethod<String>('getOSVersion');
      return result ?? 'Unknown OS';
    } catch (e) {
      throw Exception('Failed to get OS version: $e');
    }
  }
}
