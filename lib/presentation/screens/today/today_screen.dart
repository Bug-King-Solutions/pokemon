import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/flower_mon_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/animated_flower_mon.dart';
import '../../widgets/soft_button.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayAsync = ref.watch(todayFlowerMonProvider);

    return AppScaffold(
      showAppBar: false,
      body: todayAsync.when(
        data: (flowerMon) {
          if (flowerMon == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final screenSize = MediaQuery.of(context).size;
          final flowerSize = screenSize.width < screenSize.height
              ? screenSize.width * 0.95
              : screenSize.height * 0.9;

          return SizedBox.expand(
            child: Center(
              child: AnimatedFlowerMon(
                flowerMon: flowerMon,
                size: flowerSize,
                autoAnimate: true,
              ),
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
                'Error loading Flowermon',
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
