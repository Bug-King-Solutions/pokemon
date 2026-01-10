import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/presentation/widgets/update_dialog.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/soft_button.dart';
import '../../providers/update_provider.dart';
import '../../../core/di/setup_locator.dart';
import '../../../data/services/update_service.dart';
import '../../../core/theme/app_theme.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionAsync = ref.watch(currentVersionProvider);
    return AppScaffold(
      title: 'About',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '🌸',
                style: const TextStyle(fontSize: 80),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Flower-Mon',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.deepBurgundy,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: versionAsync.when(
                data: (versionInfo) => Text(
                  'Version ${versionInfo['version']} (Build ${versionInfo['buildNumber']})',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.deepBurgundy.withOpacity(0.7),
                      ),
                ),
                loading: () => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => Text(
                  'Version Unknown',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.deepBurgundy.withOpacity(0.7),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: SoftButton(
                text: 'Check for Updates',
                icon: Icons.system_update,
                fullWidth: false,
                onPressed: () async {
                  final updateService = getIt<UpdateService>();
                  final updateInfo = await updateService.checkForUpdate(forceCheck: true);
                  if (updateInfo != null && context.mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: !updateInfo.forceUpdate,
                      builder: (context) => UpdateDialog(
                        updateInfo: updateInfo,
                        updateService: updateService,
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You are using the latest version!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'About',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Flower-Mon is a daily collectible app that generates one unique animated Flower-Mon every morning. Each Flower-Mon is procedurally generated, never repeated, and stored permanently in your collection.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'Features',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(context, Icons.local_florist, 'Daily Collection'),
            _buildFeatureItem(context, Icons.auto_awesome, 'Procedural Generation'),
            _buildFeatureItem(context, Icons.notifications, 'Daily Notifications'),
            _buildFeatureItem(context, Icons.collections_bookmark, 'FlowerDex Collection'),
            _buildFeatureItem(context, Icons.palette, 'Beautiful Animations'),
            const SizedBox(height: 32),
            Text(
              'Made with 💖',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryRed),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
