import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/flower_mon_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/animated_flower_mon.dart';
import '../../widgets/type_badge.dart';
import '../../widgets/rarity_badge.dart';
import '../../widgets/soft_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/di/setup_locator.dart';
import '../../../data/services/storage_service.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayAsync = ref.watch(todayFlowerMonProvider);
    final recipientName = getIt<StorageService>().getRecipientName();

    return AppScaffold(
      title: 'Today\'s Flower-Mon',
      actions: [
        IconButton(
          icon: const Icon(Icons.collections_bookmark),
          onPressed: () => context.go('/dex'),
          tooltip: 'FlowerDex',
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.go('/settings'),
          tooltip: 'Settings',
        ),
      ],
      body: todayAsync.when(
        data: (flowerMon) {
          if (flowerMon == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (recipientName != null && recipientName.isNotEmpty) ...[
                  Text(
                    'For $recipientName 💖',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.deepBurgundy,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 24),
                AnimatedFlowerMon(
                  flowerMon: flowerMon,
                  size: 250,
                  autoAnimate: true,
                ),
                const SizedBox(height: 32),
                Text(
                  flowerMon.name,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.deepBurgundy,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TypeBadge(type: flowerMon.type),
                    const SizedBox(width: 12),
                    RarityBadge(rarity: flowerMon.rarity),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryRed.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    flowerMon.romanticMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.deepBurgundy,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                  ),
                ),
                const SizedBox(height: 32),
                SoftButton(
                  text: 'View Details',
                  icon: Icons.info_outline,
                  fullWidth: true,
                  onPressed: () => context.go('/detail/${flowerMon.id}'),
                ),
                const SizedBox(height: 16),
                SoftButton(
                  text: 'View Collection',
                  icon: Icons.collections_bookmark_outlined,
                  fullWidth: true,
                  backgroundColor: AppTheme.limeGreen,
                  onPressed: () => context.go('/dex'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading Flower-Mon',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SoftButton(
                text: 'Retry',
                icon: Icons.refresh,
                onPressed: () => ref.invalidate(todayFlowerMonProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
