import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/models/flower_mon.dart';

class FlowerPainter extends CustomPainter {
  final FlowerMon flowerMon;
  final double animationValue;
  final FlowerMonAnimationStyle animationStyle;

  FlowerPainter({
    required this.flowerMon,
    required this.animationValue,
    required this.animationStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final primaryColor = Color(flowerMon.primaryColor);
    final secondaryColor = Color(flowerMon.secondaryColor);
    final maxRadius = math.min(size.width, size.height) / 2;

    // Draw petals radiating from center (bouquet effect)
    _drawPetals(canvas, center, maxRadius, primaryColor, secondaryColor);

    // Draw center on top
    _drawCenter(canvas, center, maxRadius * 0.15, secondaryColor);
  }

  void _drawPetals(
    Canvas canvas,
    Offset center,
    double radius,
    Color primaryColor,
    Color secondaryColor,
  ) {
    final petalCount = 6;
    final angleStep = 2 * math.pi / petalCount;
    final petalRadius = radius * 0.75; // Larger petals that overlap for bouquet effect

    // Draw petals from back to front for proper overlap
    for (int i = petalCount - 1; i >= 0; i--) {
      final angle = i * angleStep;
      
      // Draw each petal radiating from center (bouquet effect with overlap)
      _drawPetal(canvas, center, petalRadius, angle, primaryColor);
    }
  }

  void _drawPetal(
    Canvas canvas,
    Offset center,
    double size,
    double rotation,
    Color color,
  ) {
    // Create paint with appropriate opacity for overlapping effect
    final paint = Paint()
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final path = Path();

    switch (flowerMon.petalShape) {
      case PetalShape.round:
        _drawRoundPetal(path, size);
        paint.color = color.withOpacity(0.65);
        break;
      case PetalShape.pointed:
        _drawPointedPetal(path, size);
        paint.color = color.withOpacity(0.7);
        break;
      case PetalShape.heart:
        _drawHeartPetal(path, size);
        paint.color = color.withOpacity(0.65);
        break;
      case PetalShape.star:
        _drawStarPetal(path, size);
        paint.color = color.withOpacity(0.7);
        break;
      case PetalShape.droplet:
        _drawDropletPetal(path, size);
        paint.color = color.withOpacity(0.7);
        break;
    }

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _drawRoundPetal(Path path, double size) {
    // Round petal radiating from center
    path.addOval(Rect.fromLTWH(-size / 2, -size / 2, size, size));
  }

  void _drawPointedPetal(Path path, double size) {
    // Pointed petal (teardrop shape) radiating from center
    path.moveTo(0, 0); // Start from center
    path.quadraticBezierTo(-size / 3, -size / 5, -size / 2.5, -size * 0.65);
    path.quadraticBezierTo(0, -size * 0.8, size / 2.5, -size * 0.65);
    path.quadraticBezierTo(size / 3, -size / 5, 0, 0);
    path.close();
  }

  void _drawHeartPetal(Path path, double size) {
    // Heart-shaped petal radiating from center
    path.moveTo(0, 0);
    path.quadraticBezierTo(-size / 4, -size / 4, -size / 2.5, -size * 0.6);
    path.quadraticBezierTo(0, -size * 0.75, size / 2.5, -size * 0.6);
    path.quadraticBezierTo(size / 4, -size / 4, 0, 0);
    path.close();
  }

  void _drawStarPetal(Path path, double size) {
    // Star-shaped petal radiating from center
    final outerRadius = size * 0.7;
    final innerRadius = size * 0.3;
    final points = 5;
    final startAngle = -math.pi / 2; // Start from top

    for (int i = 0; i < points * 2; i++) {
      final angle = startAngle + (i * math.pi / points);
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = radius * math.cos(angle);
      final y = radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
  }

  void _drawDropletPetal(Path path, double size) {
    // Droplet petal radiating from center
    path.moveTo(0, 0);
    path.quadraticBezierTo(-size / 3, -size / 4, -size / 2.5, -size * 0.7);
    path.quadraticBezierTo(0, -size * 0.85, size / 2.5, -size * 0.7);
    path.quadraticBezierTo(size / 3, -size / 4, 0, 0);
    path.close();
  }

  void _drawCenter(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.95)
      ..style = PaintingStyle.fill;

    switch (flowerMon.centerDesign) {
      case CenterDesign.simple:
        canvas.drawCircle(center, radius, paint);
        break;
      case CenterDesign.spiraled:
        _drawSpiraledCenter(canvas, center, radius, color);
        break;
      case CenterDesign.layered:
        _drawLayeredCenter(canvas, center, radius, color);
        break;
      case CenterDesign.crystalline:
        _drawCrystallineCenter(canvas, center, radius, color);
        break;
    }
  }

  void _drawSpiraledCenter(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.95)
      ..style = PaintingStyle.fill;

    for (int i = 3; i > 0; i--) {
      final layerRadius = radius * (i / 3);
      canvas.drawCircle(center, layerRadius, paint);
    }
  }

  void _drawLayeredCenter(Canvas canvas, Offset center, double radius, Color color) {
    final paint1 = Paint()
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint1);
    canvas.drawCircle(center, radius * 0.7, paint2);
    canvas.drawCircle(center, radius * 0.4, paint1);
  }

  void _drawCrystallineCenter(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.95)
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = 6;

    for (int i = 0; i < points; i++) {
      final angle = i * 2 * math.pi / points;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Add inner circle
    final innerPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.5, innerPaint);
  }

  @override
  bool shouldRepaint(FlowerPainter oldDelegate) {
    return oldDelegate.flowerMon.id != flowerMon.id ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.animationStyle != animationStyle;
  }
}
