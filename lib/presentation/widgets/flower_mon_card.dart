import 'package:flutter/material.dart';
import '../../data/models/flower_mon.dart';
import 'type_badge.dart';
import 'rarity_badge.dart';
import 'animated_flower_mon.dart';

class FlowerMonCard extends StatelessWidget {
  final FlowerMon flowerMon;
  final VoidCallback? onTap;
  final bool showAnimation;

  const FlowerMonCard({
    super.key,
    required this.flowerMon,
    this.onTap,
    this.showAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flowerMon.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          flowerMon.romanticMessage,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (showAnimation)
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: AnimatedFlowerMon(
                        flowerMon: flowerMon,
                        size: 80,
                      ),
                    )
                  else
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(flowerMon.primaryColor).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text(
                          flowerMon.typeEmoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TypeBadge(type: flowerMon.type, compact: true),
                  const SizedBox(width: 8),
                  RarityBadge(rarity: flowerMon.rarity, compact: true),
                  const Spacer(),
                  Text(
                    '${flowerMon.dateGenerated.day}/${flowerMon.dateGenerated.month}/${flowerMon.dateGenerated.year}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
