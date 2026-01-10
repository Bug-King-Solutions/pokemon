import 'package:flutter/material.dart';
import '../../data/models/flower_mon.dart';
import '../../core/theme/app_theme.dart';

class TypeBadge extends StatelessWidget {
  final FlowerMonType type;
  final bool compact;

  const TypeBadge({
    super.key,
    required this.type,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = AppTheme.typeColors[type.name] ?? AppTheme.primaryRed;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: typeColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type.emoji,
            style: TextStyle(fontSize: compact ? 12 : 14),
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              type.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBurgundy,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
