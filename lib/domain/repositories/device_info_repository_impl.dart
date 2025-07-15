import 'package:device_sensor_app/data/platform/device_platform_channel.dart';

import '../../domain/entities/device_info.dart';
import '../../domain/repositories/device_info_repository.dart';

class DeviceInfoRepositoryImpl implements DeviceInfoRepository {
  final DevicePlatformChannel platform;

  DeviceInfoRepositoryImpl(this.platform);

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    final battery = await platform.getBatteryLevel();
    final name = await platform.getDeviceName();
    final os = await platform.getOSVersion();
    return DeviceInfo(
      batteryLevel: battery,
      deviceName: name,
      osVersion: os,
    );
  }
}
