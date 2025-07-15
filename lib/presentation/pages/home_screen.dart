import 'package:device_sensor_app/presentation/widgets/animated_info_card.dart';
import 'package:device_sensor_app/presentation/widgets/feature_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../application/providers/device_info_provider.dart';
import '../../domain/entities/device_info.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceInfoAsync = ref.watch(deviceInfoFutureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Device Info')),
      body: deviceInfoAsync.when(
        loading: () => Center(
          child: Lottie.asset('assets/lottie/loading.json', width: 120),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (DeviceInfo info) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(deviceInfoFutureProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AnimatedInfoCard(
                  icon: Icons.battery_full,
                  title: 'Battery Level',
                  subtitle: '${info.batteryLevel}%',
                  color: Colors.green,
                ),
                AnimatedInfoCard(
                  icon: Icons.phone_android,
                  title: 'Device Name',
                  subtitle: info.deviceName,
                  color: Colors.blueAccent,
                ),
                AnimatedInfoCard(
                  icon: Icons.system_update,
                  title: 'OS Version',
                  subtitle: info.osVersion,
                  color: Colors.orange,
                ),
                const SizedBox(height: 30),
                FeatureButton(
                  icon: Icons.flash_on,
                  label: 'Go to Flashlight',
                  onTap: () => Navigator.pushNamed(context, '/sensor'),
                  color: Colors.amber,
                ),
                const SizedBox(height: 10),
                FeatureButton(
                  icon: Icons.sensors,
                  label: 'Go to Gyroscope',
                  onTap: () => Navigator.pushNamed(context, '/gyroscope'),
                  color: Colors.deepPurpleAccent,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
