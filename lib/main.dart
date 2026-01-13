import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'core/di/setup_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/services/storage_service.dart';
import 'data/services/notification_service.dart';
import 'presentation/widgets/update_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize sqflite database factory (required for cached_network_image)
  // This fixes the "databaseFactory not initialized" error
  databaseFactory = databaseFactory;
  
  // Initialize dependency injection
  await setupLocator();
  
  // Schedule initial notification
  final storageService = getIt<StorageService>();
  final notificationService = getIt<NotificationService>();
  final hour = storageService.getNotificationHour();
  final minute = storageService.getNotificationMinute();
  final recipientName = storageService.getRecipientName();
  
  await notificationService.scheduleDailyNotification(
    hour: hour,
    minute: minute,
    recipientName: recipientName,
  );
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UpdateChecker(
      checkOnStart: true,
      child: MaterialApp.router(
        title: 'Flowermon',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
