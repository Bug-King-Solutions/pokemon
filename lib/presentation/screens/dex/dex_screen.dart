import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dex_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/flower_mon_card.dart';
import '../../widgets/empty_dex_state.dart';
import '../../widgets/soft_button.dart';

class DexScreen extends ConsumerWidget {
  const DexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(flowerDexProvider);
    final count = ref.watch(collectionCountProvider);

    return AppScaffold(
      title: 'FlowerDex',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
      body: collectionAsync.when(
        data: (collection) {
          if (collection.isEmpty) {
            return const EmptyDexState(
              message: 'Your FlowerDex is empty.\nStart collecting daily flowermons!',
              icon: Icons.eco_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(flowerDexProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: collection.length,
              itemBuilder: (context, index) {
                final flowerMon = collection[index];
                return FlowerMonCard(
                  flowerMon: flowerMon,
                  onTap: () => context.push('/detail/${flowerMon.id}'),
                  showAnimation: false,
                );
              },
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
                'Error loading collection',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              SoftButton(
                text: 'Retry',
                icon: Icons.refresh,
                onPressed: () => ref.invalidate(flowerDexProvider),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/today'),
        icon: const Icon(Icons.today),
        label: const Text('Today'),
      ),
    );
  }
}
