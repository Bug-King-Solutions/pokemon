import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dex_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/animated_flower_mon.dart';
import '../../widgets/type_badge.dart';
import '../../widgets/rarity_badge.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/di/setup_locator.dart';
import '../../../data/services/storage_service.dart';

class DetailScreen extends ConsumerWidget {
  final String flowerMonId;

  const DetailScreen({
    super.key,
    required this.flowerMonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(flowerDexProvider);

    return AppScaffold(
      title: 'Flower-Mon Details',
      body: collectionAsync.when(
        data: (collection) {
          final flowerMon = collection.firstWhere(
            (fm) => fm.id == flowerMonId,
            orElse: () => getIt<StorageService>().getTodayFlowerMon()!,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedFlowerMon(
                  flowerMon: flowerMon,
                  size: 280,
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
                _buildDetailCard(
                  context,
                  'Type',
                  '${flowerMon.typeEmoji} ${flowerMon.typeName}',
                ),
                const SizedBox(height: 16),
                _buildDetailCard(
                  context,
                  'Rarity',
                  flowerMon.rarityName,
                ),
                const SizedBox(height: 16),
                _buildDetailCard(
                  context,
                  'Petal Shape',
                  flowerMon.petalShape.displayName,
                ),
                const SizedBox(height: 16),
                _buildDetailCard(
                  context,
                  'Center Design',
                  flowerMon.centerDesign.displayName,
                ),
                const SizedBox(height: 16),
                _buildDetailCard(
                  context,
                  'Animation',
                  flowerMon.animationStyle.displayName,
                ),
                const SizedBox(height: 16),
                _buildDetailCard(
                  context,
                  'Date Collected',
                  '${flowerMon.dateGenerated.day}/${flowerMon.dateGenerated.month}/${flowerMon.dateGenerated.year}',
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
                'Error loading details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
