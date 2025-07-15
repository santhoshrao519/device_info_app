import 'package:device_sensor_app/domain/repositories/device_info_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/platform/device_platform_channel.dart';
import '../../domain/entities/device_info.dart';
import '../../domain/usecases/get_device_info_usecase.dart';

// PlatformChannel provider
final _deviceChannelProvider = Provider((ref) => DevicePlatformChannel());

// Repository provider
final _deviceRepoProvider = Provider((ref) {
  return DeviceInfoRepositoryImpl(ref.read(_deviceChannelProvider));
});

// UseCase provider
final getDeviceInfoUseCaseProvider = Provider((ref) {
  return GetDeviceInfoUseCase(ref.read(_deviceRepoProvider));
});

// State provider
final deviceInfoFutureProvider = FutureProvider<DeviceInfo>((ref) async {
  final deviceInfo = await ref.read(getDeviceInfoUseCaseProvider).call();
  await Future.delayed(const Duration(seconds: 1));
  return deviceInfo;
});
