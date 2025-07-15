import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/gyroscope_provider.dart';
import 'dart:math';

class GyroscopeScreen extends ConsumerWidget {
  const GyroscopeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gyro = ref.watch(gyroscopeStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Gyroscope")),
      body: gyro.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (data) {
          final x = data['x'];
          final y = data['y'];
          final z = data['z'];

          final double totalRotation = sqrt(x * x + y * y + z * z);
          final color = totalRotation > 1.5 ? Colors.red : Colors.green;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  transform: Matrix4.identity()
                    ..rotateX(x)
                    ..rotateY(y)
                    ..rotateZ(z),
                  child: const Icon(Icons.rotate_90_degrees_ccw,
                      size: 60, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Text("X: ${x.toStringAsFixed(2)}"),
                Text("Y: ${y.toStringAsFixed(2)}"),
                Text("Z: ${z.toStringAsFixed(2)}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
