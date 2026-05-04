import 'package:flutter/material.dart';
import 'package:kd_pannel/core/di/service_locator.dart';
import 'package:kd_pannel/core/theme/app_theme.dart';
import 'package:kd_pannel/features/dashboard/presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrishiDealer Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainPage(),
    );
  }
}
