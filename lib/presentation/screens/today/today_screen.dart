import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../data/models/flower_mon.dart';
import '../../../data/services/generator_service.dart';
import '../../providers/flower_mon_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/ai_generated_flower.dart';
import '../../widgets/soft_button.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  Timer? _debugTimer;
  FlowerMon? _debugFlowerMon;
  int _debugCounter = 0;

  @override
  void initState() {
    super.initState();
    
    // Only start timer in debug mode
    if (kDebugMode) {
      _startDebugTimer();
    }
  }

  void _startDebugTimer() {
    _debugTimer = Timer.periodic(const Duration(seconds: 50), (timer) {
      if (mounted) {
        setState(() {
          _debugCounter++;
          // Generate a new flower with a different seed
          final generator = GetIt.instance<GeneratorService>();
          final now = DateTime.now();
          final debugDate = now.add(Duration(days: _debugCounter));
          _debugFlowerMon = generator.generateForDate(debugDate);
        });
      }
    });
  }

  @override
  void dispose() {
    _debugTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

          // Use debug flower if in debug mode and available
          final displayFlower = (kDebugMode && _debugFlowerMon != null) 
              ? _debugFlowerMon! 
              : flowerMon;

          final screenSize = MediaQuery.of(context).size;
          final flowerSize = screenSize.width < screenSize.height
              ? screenSize.width * 0.95
              : screenSize.height * 0.9;

          return Stack(
            children: [
              SizedBox.expand(
                child: Center(
                  child: AIGeneratedFlower(
                    flowerMon: displayFlower,
                    size: flowerSize,
                  ),
                ),
              ),
              // Debug indicator
              if (kDebugMode)
                Positioned(
                  top: 40,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'DEBUG: ${displayFlower.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
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
