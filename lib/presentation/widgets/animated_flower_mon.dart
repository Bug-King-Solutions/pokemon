import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/models/flower_mon.dart';
import 'flower_painter.dart';

class AnimatedFlowerMon extends StatefulWidget {
  final FlowerMon flowerMon;
  final double size;
  final bool autoAnimate;

  const AnimatedFlowerMon({
    super.key,
    required this.flowerMon,
    this.size = 200,
    this.autoAnimate = true,
  });

  @override
  State<AnimatedFlowerMon> createState() => _AnimatedFlowerMonState();
}

class _AnimatedFlowerMonState extends State<AnimatedFlowerMon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _getAnimationDuration(),
      vsync: this,
    );

    _animation = _getAnimation();

    if (widget.autoAnimate) {
      _controller.repeat(reverse: true);
    }
  }

  Duration _getAnimationDuration() {
    switch (widget.flowerMon.animationStyle) {
      case FlowerMonAnimationStyle.gentleBreathe:
        return const Duration(milliseconds: 3000);
      case FlowerMonAnimationStyle.slowSway:
        return const Duration(milliseconds: 4000);
      case FlowerMonAnimationStyle.softPulse:
        return const Duration(milliseconds: 2000);
      case FlowerMonAnimationStyle.calmGlow:
        return const Duration(milliseconds: 2500);
    }
  }

  Animation<double> _getAnimation() {
    switch (widget.flowerMon.animationStyle) {
      case FlowerMonAnimationStyle.gentleBreathe:
      case FlowerMonAnimationStyle.softPulse:
        return Tween<double>(begin: 0.9, end: 1.1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
      case FlowerMonAnimationStyle.slowSway:
        return Tween<double>(begin: -0.1, end: 0.1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
      case FlowerMonAnimationStyle.calmGlow:
        return Tween<double>(begin: 0.8, end: 1.2).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.flowerMon.animationStyle == FlowerMonAnimationStyle.slowSway
              ? 1.0
              : _animation.value,
          child: Transform.rotate(
            angle: widget.flowerMon.animationStyle == FlowerMonAnimationStyle.slowSway
                ? _animation.value * math.pi / 6
                : 0,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: FlowerPainter(
                flowerMon: widget.flowerMon,
                animationValue: _animation.value,
                animationStyle: widget.flowerMon.animationStyle,
              ),
            ),
          ),
        );
      },
    );
  }
}
