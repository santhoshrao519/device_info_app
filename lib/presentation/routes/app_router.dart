import 'package:flutter/material.dart';
import '../pages/home_screen.dart';
import '../pages/sensor_info_screen.dart';
import '../pages/gyroscope_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/sensor':
        return MaterialPageRoute(builder: (_) => const SensorInfoScreen());
      case '/gyroscope':
        return MaterialPageRoute(builder: (_) => const GyroscopeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
