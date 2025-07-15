
import 'package:device_sensor_app/data/platform/sensor_platform_channel.dart';

class ToggleFlashlightUseCase {
  final SensorPlatformChannel _platform;

  ToggleFlashlightUseCase(this._platform);

  Future<bool> call(bool turnOn) => _platform.toggleFlashlight(turnOn);
}
