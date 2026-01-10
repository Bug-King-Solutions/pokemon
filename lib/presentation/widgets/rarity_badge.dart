import 'package:flutter/material.dart';
import '../../data/models/flower_mon.dart';
import '../../core/theme/app_theme.dart';

class RarityBadge extends StatelessWidget {
  final FlowerMonRarity rarity;
  final bool compact;

  const RarityBadge({
    super.key,
    required this.rarity,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final rarityColor = AppTheme.rarityColors[rarity.name] ?? Colors.grey;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: rarityColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: rarityColor.withOpacity(0.6),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rarity == FlowerMonRarity.legendary)
            const Text(
              '✨',
              style: TextStyle(fontSize: 14),
            ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              rarity.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: rarityColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
