import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../data/models/flower_mon.dart';

class EmojiFlowerBouquet extends StatefulWidget {
  final FlowerMon flowerMon;
  final double size;

  const EmojiFlowerBouquet({
    super.key,
    required this.flowerMon,
    required this.size,
  });

  @override
  State<EmojiFlowerBouquet> createState() => _EmojiFlowerBouquetState();
}

class _EmojiFlowerBouquetState extends State<EmojiFlowerBouquet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    // Start confetti after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  List<String> _getFlowerEmojis() {
    // Different flower emojis based on petal shape
    switch (widget.flowerMon.petalShape) {
      case PetalShape.round:
        return ['🌼', '🌻', '🌺', '🏵️', '💐'];
      case PetalShape.pointed:
        return ['🌷', '🌹', '🥀', '💮', '🌸'];
      case PetalShape.heart:
        return ['🌹', '💐', '🌺', '🌷', '🏵️'];
      case PetalShape.star:
        return ['✨', '🌟', '⭐', '💫', '🌸'];
      case PetalShape.droplet:
        return ['🌸', '🌺', '🌼', '🌻', '🌷'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final flowers = _getFlowerEmojis();
    final random = math.Random(widget.flowerMon.id.hashCode);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Confetti effect
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: math.pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 10,
            gravity: 0.1,
            colors: [
              Color(widget.flowerMon.primaryColor),
              Color(widget.flowerMon.secondaryColor),
              Colors.pink,
              Colors.purple,
              Colors.white,
            ],
          ),
        ),

        // Main bouquet
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                children: [
                  // Background glow
                  Center(
                    child: Container(
                      width: widget.size * 0.8,
                      height: widget.size * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(widget.flowerMon.primaryColor).withOpacity(0.3),
                            Color(widget.flowerMon.secondaryColor).withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Flower emojis arranged in a bouquet
                  ...List.generate(12, (index) {
                    final angle = (index / 12) * 2 * math.pi;
                    final distance = widget.size * (0.15 + random.nextDouble() * 0.25);
                    final flowerIndex = random.nextInt(flowers.length);
                    final flower = flowers[flowerIndex];
                    
                    // Animation offset
                    final animOffset = math.sin(_controller.value * 2 * math.pi + index) * 5;
                    
                    return Positioned(
                      left: widget.size / 2 + distance * math.cos(angle) + animOffset,
                      top: widget.size / 2 + distance * math.sin(angle) + animOffset,
                      child: Transform.scale(
                        scale: 0.8 + random.nextDouble() * 0.4,
                        child: Transform.rotate(
                          angle: random.nextDouble() * 0.5 - 0.25,
                          child: Text(
                            flower,
                            style: TextStyle(
                              fontSize: widget.size * 0.15,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Center flower (largest)
                  Center(
                    child: Transform.scale(
                      scale: 1.0 + math.sin(_controller.value * 2 * math.pi) * 0.1,
                      child: Text(
                        flowers[0],
                        style: TextStyle(
                          fontSize: widget.size * 0.25,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Sparkles
                  ...List.generate(8, (index) {
                    final angle = (index / 8) * 2 * math.pi + _controller.value * 2 * math.pi;
                    final distance = widget.size * 0.35;
                    
                    return Positioned(
                      left: widget.size / 2 + distance * math.cos(angle),
                      top: widget.size / 2 + distance * math.sin(angle),
                      child: Opacity(
                        opacity: (math.sin(_controller.value * 4 * math.pi + index) + 1) / 2,
                        child: Text(
                          '✨',
                          style: TextStyle(
                            fontSize: widget.size * 0.08,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),

        // Flower name overlay
        Positioned(
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Color(widget.flowerMon.primaryColor).withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.flowerMon.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
