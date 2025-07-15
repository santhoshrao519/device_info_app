import 'package:device_sensor_app/domain/repositories/sensor_repository_impl.dart';
import 'package:device_sensor_app/domain/usecases/toggle_flashlight_usecase.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/platform/sensor_platform_channel.dart';
final sensorPlatformChannelProvider = Provider((ref) => SensorPlatformChannel());

final toggleFlashlightUseCaseProvider = Provider(
  (ref) => ToggleFlashlightUseCase(ref.read(sensorPlatformChannelProvider)),
);

final flashlightStateProvider = StateProvider<bool>((ref) => false); // Default state
