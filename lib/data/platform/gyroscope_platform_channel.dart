import 'dart:async';
import 'package:flutter/services.dart';

class GyroscopePlatformChannel {
  static const _channel = MethodChannel('sensor_channel');
  static const _eventChannel = EventChannel('sensor_channel/gyroscope');

  Stream<Map<String, dynamic>> getGyroscopeStream() {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event);
      return map;
    });
  }
}
