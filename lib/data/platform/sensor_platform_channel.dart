import 'package:flutter/services.dart';

class SensorPlatformChannel {
  static const _channel = MethodChannel('sensor_channel');

  /// Toggle flashlight ON or OFF
  Future<bool> toggleFlashlight(bool turnOn) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'toggleFlashlight',
        {'turnOn': turnOn},
      );
      return result ?? false;
    } catch (e) {
      throw Exception('Flashlight toggle failed: $e');
    }
  }

  /// Get current flashlight status (native boolean state)
  Future<bool> getFlashlightStatus() async {
    try {
      final result = await _channel.invokeMethod<bool>('getFlashlightStatus');
      return result ?? false;
    } catch (e) {
      throw Exception('Fetching flashlight status failed: $e');
    }
  }

  /// Optional: check if device supports flashlight
  Future<bool> hasFlashlight() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasFlashlight');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
}
