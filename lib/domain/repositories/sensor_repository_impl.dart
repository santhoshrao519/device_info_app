import 'package:device_sensor_app/data/platform/sensor_platform_channel.dart';

import '../../domain/repositories/sensor_repository.dart';

class SensorRepositoryImpl implements SensorRepository {
  final SensorPlatformChannel platform;

  SensorRepositoryImpl(this.platform);

  @override
  Future<bool> toggleFlashlight(bool turnOn) {
    return platform.toggleFlashlight(turnOn);
  }
}
