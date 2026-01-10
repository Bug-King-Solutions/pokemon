import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EmptyDexState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyDexState({
    super.key,
    this.message = 'No flowermons collected yet.\nStart collecting daily!',
    this.icon = Icons.eco_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppTheme.deepBurgundy.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.deepBurgundy.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
