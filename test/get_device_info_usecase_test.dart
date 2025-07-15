import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:device_sensor_app/domain/entities/device_info.dart';
import 'package:device_sensor_app/domain/usecases/get_device_info_usecase.dart';

import 'mocks.mocks.dart';


void main() {
  late MockDeviceInfoRepository mockRepository;
  late GetDeviceInfoUseCase useCase;

  setUp(() {
    mockRepository = MockDeviceInfoRepository();
    useCase = GetDeviceInfoUseCase(mockRepository);
  });

  test('should return device info from repository', () async {
    final testInfo = DeviceInfo(
      batteryLevel: 88,
      deviceName: 'Pixel 6',
      osVersion: 'Android 14',
    );

    when(mockRepository.getDeviceInfo()).thenAnswer((_) async => testInfo);

    final result = await useCase.call();

    expect(result, testInfo);
    verify(mockRepository.getDeviceInfo()).called(1);
  });
}
