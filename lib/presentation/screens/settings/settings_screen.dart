import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/soft_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/di/setup_locator.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _nameController;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    final storageService = getIt<StorageService>();
    final hour = storageService.getNotificationHour();
    final minute = storageService.getNotificationMinute();
    _selectedTime = TimeOfDay(hour: hour, minute: minute);
    _nameController = TextEditingController(
      text: storageService.getRecipientName() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      final timeNotifier = ref.read(notificationTimeProvider.notifier);
      await timeNotifier.updateTime(picked.hour, picked.minute);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification time updated'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _saveRecipientName() async {
    final nameNotifier = ref.read(recipientNameProvider.notifier);
    await nameNotifier.updateName(_nameController.text);
    
    // Reschedule notification with new name
    final time = ref.read(notificationTimeProvider);
    final notificationService = getIt<NotificationService>();
    await notificationService.scheduleDailyNotification(
      hour: time.hour,
      minute: time.minute,
      recipientName: _nameController.text.isEmpty ? null : _nameController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipient name saved'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _testNotification() async {
    final notificationService = getIt<NotificationService>();
    await notificationService.showTestNotification();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test notification sent'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationTime = ref.watch(notificationTimeProvider);

    return AppScaffold(
      title: 'Settings',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recipient Name',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter name (e.g., "Amara")',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SoftButton(
                    text: 'Save Name',
                    icon: Icons.save,
                    fullWidth: true,
                    onPressed: _saveRecipientName,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Notification',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Notification Time'),
                    subtitle: Text(notificationTime.displayTime),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _selectTime(context),
                  ),
                  const SizedBox(height: 8),
                  SoftButton(
                    text: 'Test Notification',
                    icon: Icons.notifications_active,
                    fullWidth: true,
                    backgroundColor: AppTheme.limeGreen,
                    onPressed: _testNotification,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/about'),
            ),
          ),
        ],
      ),
    );
  }
}
