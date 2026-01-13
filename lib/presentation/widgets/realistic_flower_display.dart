import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/models/flower_mon.dart';

/// Uses curated flower image URLs for realistic flower display
class RealisticFlowerDisplay extends StatefulWidget {
  final FlowerMon flowerMon;
  final double size;

  const RealisticFlowerDisplay({
    super.key,
    required this.flowerMon,
    required this.size,
  });

  @override
  State<RealisticFlowerDisplay> createState() => _RealisticFlowerDisplayState();
}

class _RealisticFlowerDisplayState extends State<RealisticFlowerDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Get flower image URL based on FlowerMon properties
  /// Using Unsplash Source for high-quality, free flower images
  String _getFlowerImageUrl() {
    final random = math.Random(widget.flowerMon.id.hashCode);
    final seed = widget.flowerMon.id.hashCode.abs();
    
    // Different flower types based on petal shape
    String flowerType;
    switch (widget.flowerMon.petalShape) {
      case PetalShape.round:
        final types = ['daisy', 'sunflower', 'gerbera', 'chrysanthemum'];
        flowerType = types[random.nextInt(types.length)];
        break;
      case PetalShape.pointed:
        final types = ['lily', 'tulip', 'iris', 'orchid'];
        flowerType = types[random.nextInt(types.length)];
        break;
      case PetalShape.heart:
        final types = ['rose', 'peony', 'carnation', 'camellia'];
        flowerType = types[random.nextInt(types.length)];
        break;
      case PetalShape.star:
        final types = ['jasmine', 'plumeria', 'magnolia', 'gardenia'];
        flowerType = types[random.nextInt(types.length)];
        break;
      case PetalShape.droplet:
        final types = ['lotus', 'waterlily', 'hibiscus', 'poppy'];
        flowerType = types[random.nextInt(types.length)];
        break;
    }

    // Use Unsplash Source API for random flower images
    // Format: https://source.unsplash.com/800x800/?flower,type&sig=seed
    return 'https://source.unsplash.com/800x800/?flower,$flowerType&sig=$seed';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final breatheScale = 1.0 + (math.sin(_controller.value * 2 * math.pi) * 0.03);
        
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background gradient glow
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(widget.flowerMon.primaryColor).withOpacity(0.4),
                    Color(widget.flowerMon.secondaryColor).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Main flower image
            Transform.scale(
              scale: breatheScale,
              child: Container(
                width: widget.size * 0.85,
                height: widget.size * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    _getFlowerImageUrl(),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(widget.flowerMon.primaryColor),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to gradient circle if image fails
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(widget.flowerMon.primaryColor),
                              Color(widget.flowerMon.secondaryColor),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.local_florist,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Decorative particles
            ...List.generate(12, (index) {
              final angle = (index / 12) * 2 * math.pi + _controller.value * 0.5;
              final distance = widget.size * 0.48;
              final opacity = (math.sin(_controller.value * 4 * math.pi + index) + 1) / 2;
              
              return Positioned(
                left: widget.size / 2 + distance * math.cos(angle) - 8,
                top: widget.size / 2 + distance * math.sin(angle) - 8,
                child: Opacity(
                  opacity: opacity * 0.6,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(widget.flowerMon.primaryColor),
                      boxShadow: [
                        BoxShadow(
                          color: Color(widget.flowerMon.primaryColor).withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Flower name badge
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(widget.flowerMon.primaryColor),
                      Color(widget.flowerMon.secondaryColor),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.flowerMon.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getRarityText(widget.flowerMon.rarity),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getRarityText(FlowerMonRarity rarity) {
    switch (rarity) {
      case FlowerMonRarity.common:
        return 'COMMON';
      case FlowerMonRarity.rare:
        return 'RARE ★';
      case FlowerMonRarity.epic:
        return 'EPIC ★★';
      case FlowerMonRarity.legendary:
        return 'LEGENDARY ★★★';
    }
  }
}
