import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/platform/gyroscope_platform_channel.dart';

final gyroscopePlatformProvider = Provider((ref) => GyroscopePlatformChannel());

final gyroscopeStreamProvider = StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  return ref.read(gyroscopePlatformProvider).getGyroscopeStream();
});
