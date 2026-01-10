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

    // Draw petals
    _drawPetals(canvas, center, size.width / 2, primaryColor, secondaryColor);

    // Draw center
    _drawCenter(canvas, center, size.width / 4, secondaryColor);
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

    for (int i = 0; i < petalCount; i++) {
      final angle = i * angleStep;
      final petalCenter = Offset(
        center.dx + math.cos(angle) * (radius * 0.4),
        center.dy + math.sin(angle) * (radius * 0.4),
      );

      _drawPetal(canvas, petalCenter, radius * 0.6, angle, primaryColor);
    }
  }

  void _drawPetal(
    Canvas canvas,
    Offset center,
    double size,
    double rotation,
    Color color,
  ) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final path = Path();

    switch (flowerMon.petalShape) {
      case PetalShape.round:
        _drawRoundPetal(path, size);
        break;
      case PetalShape.pointed:
        _drawPointedPetal(path, size);
        break;
      case PetalShape.heart:
        _drawHeartPetal(path, size);
        break;
      case PetalShape.star:
        _drawStarPetal(path, size);
        break;
      case PetalShape.droplet:
        _drawDropletPetal(path, size);
        break;
    }

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _drawRoundPetal(Path path, double size) {
    path.addOval(Rect.fromLTWH(-size / 2, -size / 3, size, size * 2 / 3));
  }

  void _drawPointedPetal(Path path, double size) {
    path.moveTo(0, -size / 2);
    path.quadraticBezierTo(-size / 2, 0, 0, size / 2);
    path.quadraticBezierTo(size / 2, 0, 0, -size / 2);
    path.close();
  }

  void _drawHeartPetal(Path path, double size) {
    path.moveTo(0, size / 3);
    path.quadraticBezierTo(-size / 3, size / 3, -size / 3, 0);
    path.quadraticBezierTo(-size / 3, -size / 6, 0, -size / 3);
    path.quadraticBezierTo(size / 3, -size / 6, size / 3, 0);
    path.quadraticBezierTo(size / 3, size / 3, 0, size / 3);
    path.close();
  }

  void _drawStarPetal(Path path, double size) {
    final outerRadius = size / 2;
    final innerRadius = size / 4;
    final points = 5;

    for (int i = 0; i < points * 2; i++) {
      final angle = i * math.pi / points;
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
    path.moveTo(0, -size / 2);
    path.quadraticBezierTo(-size / 2, size / 4, 0, size / 2);
    path.quadraticBezierTo(size / 2, size / 4, 0, -size / 2);
    path.close();
  }

  void _drawCenter(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.9)
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
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    for (int i = 3; i > 0; i--) {
      final layerRadius = radius * (i / 3);
      canvas.drawCircle(center, layerRadius, paint);
    }
  }

  void _drawLayeredCenter(Canvas canvas, Offset center, double radius, Color color) {
    final paint1 = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint1);
    canvas.drawCircle(center, radius * 0.7, paint2);
    canvas.drawCircle(center, radius * 0.4, paint1);
  }

  void _drawCrystallineCenter(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.9)
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
      ..color = color.withOpacity(0.6)
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
