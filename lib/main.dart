import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/providers/task_list_provider.dart';
import 'package:to_do_list/services/notification.service.dart';
import 'package:to_do_list/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:to_do_list/layout/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationStatus = await Permission.notification.status;
  if (!notificationStatus.isGranted) {
    await Permission.notification.request();
  }

  NotificationService().initNotification();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskListProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: MainColors.primary_300,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: TextColors.color_800,
        ),
      ),
      home: const Navigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
