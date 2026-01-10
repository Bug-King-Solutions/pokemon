import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/setup_locator.dart';
import '../../data/models/flower_mon.dart';
import '../../data/services/storage_service.dart';

// Collection (FlowerDex) Provider
final flowerDexProvider = FutureProvider<List<FlowerMon>>((ref) async {
  final storageService = getIt<StorageService>();
  return storageService.getAllFlowerMons();
});

// Collection count provider
final collectionCountProvider = Provider<int>((ref) {
  final collectionAsync = ref.watch(flowerDexProvider);
  return collectionAsync.when(
    data: (collection) => collection.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Refresh collection
final refreshDexProvider = Provider((ref) {
  return () => ref.invalidate(flowerDexProvider);
});
