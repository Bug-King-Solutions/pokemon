import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/setup_locator.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/notification_service.dart';

// Recipient name provider
final recipientNameProvider = StateNotifierProvider<RecipientNameNotifier, String?>((ref) {
  final storageService = getIt<StorageService>();
  final initialName = storageService.getRecipientName();
  return RecipientNameNotifier(initialName ?? '');
});

class RecipientNameNotifier extends StateNotifier<String?> {
  RecipientNameNotifier(super.state);
  
  final _storageService = getIt<StorageService>();
  
  Future<void> updateName(String name) async {
    await _storageService.setRecipientName(name);
    state = name.isEmpty ? null : name;
  }
}

// Notification time provider
final notificationTimeProvider = StateNotifierProvider<NotificationTimeNotifier, NotificationTime>((ref) {
  final storageService = getIt<StorageService>();
  final hour = storageService.getNotificationHour();
  final minute = storageService.getNotificationMinute();
  return NotificationTimeNotifier(hour, minute);
});

class NotificationTime {
  final int hour;
  final int minute;
  
  NotificationTime(this.hour, this.minute);
  
  String get displayTime {
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final amPm = hour >= 12 ? 'PM' : 'AM';
    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm';
  }
}

class NotificationTimeNotifier extends StateNotifier<NotificationTime> {
  NotificationTimeNotifier(int hour, int minute)
      : super(NotificationTime(hour, minute));
  
  final _storageService = getIt<StorageService>();
  final _notificationService = getIt<NotificationService>();
  
  Future<void> updateTime(int hour, int minute) async {
    await _storageService.setNotificationHour(hour);
    await _storageService.setNotificationMinute(minute);
    state = NotificationTime(hour, minute);
    
    // Reschedule notification
    final recipientName = _storageService.getRecipientName();
    await _notificationService.scheduleDailyNotification(
      hour: hour,
      minute: minute,
      recipientName: recipientName,
    );
  }
}
