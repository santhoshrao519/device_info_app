import 'package:device_sensor_app/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/sensor_provider.dart';

class SensorInfoScreen extends ConsumerStatefulWidget {
  const SensorInfoScreen({super.key});

  @override
  ConsumerState<SensorInfoScreen> createState() => _SensorInfoScreenState();
}

class _SensorInfoScreenState extends ConsumerState<SensorInfoScreen> {
  @override
  void initState() {
    super.initState();
    _loadFlashStatus(); // Initialize flashlight state from platform
  }

  Future<void> _loadFlashStatus() async {
    final platform = ref.read(sensorPlatformChannelProvider);
    try {
      final status = await platform.getFlashlightStatus();
      ref.read(flashlightStateProvider.notifier).state = status;
    } catch (_) {
      SnackBarUtils.error(context, 'Failed to load flashlight status');
    }
  }

  Future<void> _toggleFlashlight(bool value) async {
    final toggle = ref.read(toggleFlashlightUseCaseProvider);
    final success = await toggle(value);
    if (success) {
      ref.read(flashlightStateProvider.notifier).state = value;
    } else {
      SnackBarUtils.error(context, 'Failed to toggle flashlight');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFlashOn = ref.watch(flashlightStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sensor Info')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isFlashOn
                  ? const Icon(Icons.flash_on,
                      key: ValueKey(true), size: 150, color: Colors.yellow)
                  : const Icon(Icons.flash_off,
                      key: ValueKey(false), size: 150, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SwitchListTile.adaptive(
              title: const Text('Flashlight'),
              value: isFlashOn,
              onChanged: _toggleFlashlight,
            ),
          ],
        ),
      ),
    );
  }
}
