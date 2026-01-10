import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/setup_locator.dart';
import '../../data/models/app_update_info.dart';
import '../../data/services/update_service.dart';

final updateServiceProvider = Provider<UpdateService>((ref) {
  return UpdateService();
});

final updateCheckProvider = FutureProvider<AppUpdateInfo?>((ref) async {
  final updateService = ref.watch(updateServiceProvider);
  return await updateService.checkForUpdate();
});

final currentVersionProvider = FutureProvider<Map<String, String>>((ref) async {
  final updateService = ref.watch(updateServiceProvider);
  return await updateService.getCurrentVersionInfo();
});
