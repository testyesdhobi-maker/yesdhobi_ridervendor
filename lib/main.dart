import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/theme.dart';
import 'package:yesdhobi_ridervendor/screens/splash_screen.dart';
import 'package:yesdhobi_ridervendor/services/rider_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiderNotificationService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RiderNotificationService.instance.navigatorKey,
      title: 'Yes Dhobi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
