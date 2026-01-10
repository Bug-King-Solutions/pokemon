import 'package:get_it/get_it.dart';
import '../../data/services/generator_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/update_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Services
  getIt.registerLazySingleton<GeneratorService>(() => GeneratorService());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<UpdateService>(() => UpdateService());

  // Initialize services
  await getIt<StorageService>().init();
  await getIt<NotificationService>().init();
}
