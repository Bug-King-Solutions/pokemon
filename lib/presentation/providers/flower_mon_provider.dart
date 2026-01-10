import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/setup_locator.dart';
import '../../data/models/flower_mon.dart';
import '../../data/services/generator_service.dart';
import '../../data/services/storage_service.dart';

// Today's Flowermon Provider
final todayFlowerMonProvider = FutureProvider<FlowerMon?>((ref) async {
  final storageService = getIt<StorageService>();
  final generatorService = getIt<GeneratorService>();
  
  // Get today's date (normalized to just date, no time)
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  // Check if we already have today's flowermon
  final saved = storageService.getTodayFlowerMon();
  
  if (saved != null) {
    // Check if it's actually from today
    final savedDate = DateTime(
      saved.dateGenerated.year,
      saved.dateGenerated.month,
      saved.dateGenerated.day,
    );
    
    if (savedDate.isAtSameMomentAs(today)) {
      return saved;
    }
  }
  
  // Generate new flowermon for today
  final newFlowerMon = generatorService.generateForDate(today);
  await storageService.saveTodayFlowerMon(newFlowerMon);
  
  return newFlowerMon;
});

// Refresh today's flowermon
final refreshTodayFlowerMonProvider = Provider((ref) {
  return () => ref.invalidate(todayFlowerMonProvider);
});
