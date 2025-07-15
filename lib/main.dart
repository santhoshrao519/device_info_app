import 'package:device_sensor_app/presentation/pages/gyroscope_screen.dart';
import 'package:device_sensor_app/presentation/pages/home_screen.dart';
import 'package:device_sensor_app/presentation/pages/sensor_info_screen.dart';
import 'package:device_sensor_app/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}
