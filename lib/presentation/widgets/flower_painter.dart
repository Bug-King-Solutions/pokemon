import 'dart:math' as math;
import 'dart:ui' as ui;
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

    // Draw a bouquet of flowers (multiple flowers clustered together)
    _drawFlowerBouquet(canvas, center, maxRadius, primaryColor, secondaryColor);
  }

  void _drawFlowerBouquet(
    Canvas canvas,
    Offset center,
    double maxRadius,
    Color primaryColor,
    Color secondaryColor,
  ) {
    final random = math.Random(flowerMon.id.hashCode);
    
    // Create color variations for the bouquet
    final colorVariations = _generateColorVariations(primaryColor, secondaryColor, random);
    
    // Number of main flowers (4-7 flowers for a full bouquet)
    final mainFlowerCount = 4 + random.nextInt(4);
    
    // Draw stems first (background)
    _drawStems(canvas, center, maxRadius, random, mainFlowerCount);
    
    // Draw leaves/foliage
    _drawFoliage(canvas, center, maxRadius, primaryColor, random);
    
    // Create main flower positions
    final flowers = <Map<String, dynamic>>[];
    
    for (int i = 0; i < mainFlowerCount; i++) {
      final angle = (i / mainFlowerCount) * 2 * math.pi + random.nextDouble() * 0.6;
      final distance = maxRadius * (0.05 + random.nextDouble() * 0.45);
      final size = 0.35 + random.nextDouble() * 0.35; // Varied sizes
      final rotation = random.nextDouble() * 2 * math.pi;
      final depth = random.nextDouble();
      
      flowers.add({
        'position': Offset(
          center.dx + distance * math.cos(angle),
          center.dy + distance * math.sin(angle),
        ),
        'size': size,
        'rotation': rotation,
        'depth': depth,
        'colorIndex': i % colorVariations.length,
        'flowerType': i % 3, // Vary flower types
      });
    }
    
    // Sort by depth (back to front)
    flowers.sort((a, b) => (a['depth'] as double).compareTo(b['depth'] as double));
    
    // Draw each flower based on petal shape
    for (final flower in flowers) {
      final pos = flower['position'] as Offset;
      final size = flower['size'] as double;
      final rotation = flower['rotation'] as double;
      final colorIndex = flower['colorIndex'] as int;
      final colors = colorVariations[colorIndex];
      final flowerType = flower['flowerType'] as int;
      
      final flowerRadius = maxRadius * size;
      
      // Draw different flower types based on FlowerMon's petal shape
      switch (flowerMon.petalShape) {
        case PetalShape.round:
          _drawDaisyFlower(canvas, pos, flowerRadius, colors['primary']!, colors['secondary']!, rotation);
          break;
        case PetalShape.pointed:
          _drawPointedFlower(canvas, pos, flowerRadius, colors['primary']!, colors['secondary']!, rotation);
          break;
        case PetalShape.heart:
          if (flowerType == 0) {
            _draw3DRose(canvas, pos, flowerRadius, colors['primary']!, colors['secondary']!, rotation);
          } else {
            _drawHeartFlower(canvas, pos, flowerRadius, colors['primary']!, colors['secondary']!, rotation);
          }
          break;
        case PetalShape.star:
          _drawStarFlower(canvas, pos, flowerRadius, colors['primary']!, colors['secondary']!, rotation);
          break;
        case PetalShape.droplet:
          _drawDropletFlower(canvas, pos, flowerRadius, colors['primary']!, colors['secondary']!, rotation);
          break;
      }
    }
  }

  void _drawStems(Canvas canvas, Offset center, double radius, math.Random random, int stemCount) {
    final stemPaint = Paint()
      ..color = const Color(0xFF6B8E23).withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < stemCount; i++) {
      final angle = (i / stemCount) * 2 * math.pi + random.nextDouble() * 0.5;
      final distance = radius * (0.05 + random.nextDouble() * 0.45);
      final stemLength = radius * (0.6 + random.nextDouble() * 0.3);
      
      final flowerPos = Offset(
        center.dx + distance * math.cos(angle),
        center.dy + distance * math.sin(angle),
      );
      
      final stemStart = Offset(
        center.dx,
        center.dy + stemLength,
      );
      
      // Draw curved stem
      final path = Path();
      path.moveTo(stemStart.dx, stemStart.dy);
      path.quadraticBezierTo(
        center.dx + (flowerPos.dx - center.dx) * 0.3,
        center.dy + stemLength * 0.6,
        flowerPos.dx,
        flowerPos.dy,
      );
      
      canvas.drawPath(path, stemPaint);
    }
  }

  void _drawFoliage(Canvas canvas, Offset center, double radius, Color baseColor, math.Random random) {
    // Draw decorative leaves around the bouquet
    final leafColor = Color.lerp(baseColor, Colors.green, 0.6)!.withOpacity(0.7);
    final darkLeafColor = Color.lerp(leafColor, Colors.black, 0.3)!;
    
    final leafCount = 8 + random.nextInt(6);
    
    for (int i = 0; i < leafCount; i++) {
      final angle = (i / leafCount) * 2 * math.pi + random.nextDouble() * 0.5;
      final distance = radius * (0.5 + random.nextDouble() * 0.35);
      final leafSize = radius * (0.15 + random.nextDouble() * 0.15);
      
      final leafPos = Offset(
        center.dx + distance * math.cos(angle),
        center.dy + distance * math.sin(angle),
      );
      
      _drawLeaf(canvas, leafPos, leafSize, angle, leafColor, darkLeafColor);
    }
  }

  void _drawLeaf(Canvas canvas, Offset position, double size, double angle, Color color, Color darkColor) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);
    
    final leafPath = Path();
    leafPath.moveTo(0, 0);
    leafPath.quadraticBezierTo(-size * 0.3, -size * 0.4, -size * 0.2, -size * 0.8);
    leafPath.quadraticBezierTo(0, -size, size * 0.2, -size * 0.8);
    leafPath.quadraticBezierTo(size * 0.3, -size * 0.4, 0, 0);
    leafPath.close();
    
    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(leafPath, shadowPaint);
    
    // Gradient
    final leafPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(-size * 0.2, 0),
        Offset(size * 0.2, -size),
        [darkColor, color, color],
        [0.0, 0.3, 1.0],
      );
    canvas.drawPath(leafPath, leafPaint);
    
    // Vein
    final veinPaint = Paint()
      ..color = darkColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, 0), Offset(0, -size * 0.9), veinPaint);
    
    canvas.restore();
  }

  void _drawDaisyFlower(Canvas canvas, Offset center, double radius, Color primaryColor, Color secondaryColor, double rotation) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    
    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(0, 0), radius * 0.9, shadowPaint);
    
    // Draw petals (daisy-like, radiating from center)
    final petalCount = 12 + (flowerMon.id.hashCode % 8);
    final angleStep = 2 * math.pi / petalCount;
    
    for (int i = 0; i < petalCount; i++) {
      final angle = i * angleStep;
      _drawSimplePetal(canvas, Offset(0, 0), radius, angle, primaryColor, secondaryColor);
    }
    
    // Draw center (yellow/dark center like a daisy)
    _drawFlowerCenter(canvas, Offset(0, 0), radius * 0.25, secondaryColor);
    
    canvas.restore();
  }

  void _drawSimplePetal(Canvas canvas, Offset center, double radius, double angle, Color primaryColor, Color secondaryColor) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    final petalLength = radius * 0.7;
    final petalWidth = radius * 0.2;
    
    final petalPath = Path();
    petalPath.moveTo(0, 0);
    petalPath.quadraticBezierTo(
      -petalWidth * 0.5, -petalLength * 0.4,
      -petalWidth * 0.4, -petalLength * 0.8,
    );
    petalPath.quadraticBezierTo(
      0, -petalLength,
      petalWidth * 0.4, -petalLength * 0.8,
    );
    petalPath.quadraticBezierTo(
      petalWidth * 0.5, -petalLength * 0.4,
      0, 0,
    );
    petalPath.close();
    
    // Gradient
    final petalPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, -petalLength * 0.2),
        Offset(0, -petalLength * 0.9),
        [
          Color.lerp(primaryColor, secondaryColor, 0.3)!,
          primaryColor,
          Color.lerp(primaryColor, Colors.white, 0.15)!,
        ],
        [0.0, 0.6, 1.0],
      );
    
    canvas.drawPath(petalPath, petalPaint);
    
    // Subtle edge highlight
    final edgePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(petalPath, edgePaint);
    
    canvas.restore();
  }

  void _drawFlowerCenter(Canvas canvas, Offset center, double radius, Color color) {
    // Gradient center
    final centerPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          Color.lerp(color, Colors.black, 0.3)!,
          color,
          Color.lerp(color, Colors.yellow, 0.2)!,
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(center, radius, centerPaint);
    
    // Add texture dots
    final dotPaint = Paint()
      ..color = Color.lerp(color, Colors.black, 0.4)!.withOpacity(0.6);
    
    final random = math.Random(flowerMon.id.hashCode);
    for (int i = 0; i < 40; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final distance = random.nextDouble() * radius * 0.8;
      final dotSize = random.nextDouble() * 1.5 + 0.5;
      
      final dotPos = Offset(
        center.dx + distance * math.cos(angle),
        center.dy + distance * math.sin(angle),
      );
      
      canvas.drawCircle(dotPos, dotSize, dotPaint);
    }
  }

  void _drawPointedFlower(Canvas canvas, Offset center, double radius, Color primaryColor, Color secondaryColor, double rotation) {
    // Similar to daisy but with pointed petals (like gerbera)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(0, 0), radius * 0.9, shadowPaint);
    
    final petalCount = 16 + (flowerMon.id.hashCode % 8);
    final angleStep = 2 * math.pi / petalCount;
    
    for (int i = 0; i < petalCount; i++) {
      final angle = i * angleStep;
      _drawPointedPetal(canvas, Offset(0, 0), radius, angle, primaryColor, secondaryColor);
    }
    
    _drawFlowerCenter(canvas, Offset(0, 0), radius * 0.22, secondaryColor);
    
    canvas.restore();
  }

  void _drawPointedPetal(Canvas canvas, Offset center, double radius, double angle, Color primaryColor, Color secondaryColor) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    final petalLength = radius * 0.75;
    final petalWidth = radius * 0.15;
    
    final petalPath = Path();
    petalPath.moveTo(0, 0);
    petalPath.quadraticBezierTo(
      -petalWidth * 0.4, -petalLength * 0.5,
      -petalWidth * 0.25, -petalLength * 0.85,
    );
    petalPath.quadraticBezierTo(
      0, -petalLength,
      petalWidth * 0.25, -petalLength * 0.85,
    );
    petalPath.quadraticBezierTo(
      petalWidth * 0.4, -petalLength * 0.5,
      0, 0,
    );
    petalPath.close();
    
    final petalPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, -petalLength * 0.1),
        Offset(0, -petalLength * 0.95),
        [
          Color.lerp(secondaryColor, Colors.black, 0.2)!,
          primaryColor,
          Color.lerp(primaryColor, Colors.white, 0.2)!,
        ],
        [0.0, 0.5, 1.0],
      );
    
    canvas.drawPath(petalPath, petalPaint);
    canvas.restore();
  }

  void _drawHeartFlower(Canvas canvas, Offset center, double radius, Color primaryColor, Color secondaryColor, double rotation) {
    // Simpler heart-shaped petals (not full rose)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(0, 0), radius * 0.9, shadowPaint);
    
    final petalCount = 8;
    final angleStep = 2 * math.pi / petalCount;
    
    for (int i = 0; i < petalCount; i++) {
      final angle = i * angleStep;
      _drawHeartPetal(canvas, Offset(0, 0), radius, angle, primaryColor, secondaryColor);
    }
    
    _drawFlowerCenter(canvas, Offset(0, 0), radius * 0.2, secondaryColor);
    
    canvas.restore();
  }

  void _drawHeartPetal(Canvas canvas, Offset center, double radius, double angle, Color primaryColor, Color secondaryColor) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    final petalLength = radius * 0.65;
    final petalWidth = radius * 0.3;
    
    final petalPath = Path();
    petalPath.moveTo(0, 0);
    petalPath.cubicTo(
      -petalWidth * 0.5, -petalLength * 0.3,
      -petalWidth * 0.4, -petalLength * 0.7,
      0, -petalLength * 0.85,
    );
    petalPath.cubicTo(
      petalWidth * 0.4, -petalLength * 0.7,
      petalWidth * 0.5, -petalLength * 0.3,
      0, 0,
    );
    petalPath.close();
    
    final petalPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, -petalLength),
        [
          secondaryColor,
          primaryColor,
          Color.lerp(primaryColor, Colors.white, 0.15)!,
        ],
        [0.0, 0.5, 1.0],
      );
    
    canvas.drawPath(petalPath, petalPaint);
    canvas.restore();
  }

  void _drawStarFlower(Canvas canvas, Offset center, double radius, Color primaryColor, Color secondaryColor, double rotation) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(0, 0), radius * 0.9, shadowPaint);
    
    final petalCount = 10;
    final angleStep = 2 * math.pi / petalCount;
    
    for (int i = 0; i < petalCount; i++) {
      final angle = i * angleStep;
      _drawStarPetal(canvas, Offset(0, 0), radius, angle, primaryColor, secondaryColor);
    }
    
    _drawFlowerCenter(canvas, Offset(0, 0), radius * 0.18, secondaryColor);
    
    canvas.restore();
  }

  void _drawStarPetal(Canvas canvas, Offset center, double radius, double angle, Color primaryColor, Color secondaryColor) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    final petalLength = radius * 0.8;
    final petalWidth = radius * 0.12;
    
    final petalPath = Path();
    petalPath.moveTo(0, 0);
    petalPath.lineTo(-petalWidth * 0.5, -petalLength * 0.3);
    petalPath.lineTo(-petalWidth * 0.3, -petalLength * 0.7);
    petalPath.lineTo(0, -petalLength);
    petalPath.lineTo(petalWidth * 0.3, -petalLength * 0.7);
    petalPath.lineTo(petalWidth * 0.5, -petalLength * 0.3);
    petalPath.close();
    
    final petalPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, -petalLength),
        [
          secondaryColor,
          primaryColor,
          Color.lerp(primaryColor, Colors.white, 0.2)!,
        ],
        [0.0, 0.6, 1.0],
      );
    
    canvas.drawPath(petalPath, petalPaint);
    canvas.restore();
  }

  void _drawDropletFlower(Canvas canvas, Offset center, double radius, Color primaryColor, Color secondaryColor, double rotation) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(0, 0), radius * 0.9, shadowPaint);
    
    final petalCount = 10;
    final angleStep = 2 * math.pi / petalCount;
    
    for (int i = 0; i < petalCount; i++) {
      final angle = i * angleStep;
      _drawDropletPetal(canvas, Offset(0, 0), radius, angle, primaryColor, secondaryColor);
    }
    
    _drawFlowerCenter(canvas, Offset(0, 0), radius * 0.23, secondaryColor);
    
    canvas.restore();
  }

  void _drawDropletPetal(Canvas canvas, Offset center, double radius, double angle, Color primaryColor, Color secondaryColor) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    final petalLength = radius * 0.7;
    final petalWidth = radius * 0.25;
    
    final petalPath = Path();
    petalPath.moveTo(0, 0);
    petalPath.quadraticBezierTo(
      -petalWidth * 0.5, -petalLength * 0.3,
      -petalWidth * 0.35, -petalLength * 0.75,
    );
    petalPath.quadraticBezierTo(
      0, -petalLength,
      petalWidth * 0.35, -petalLength * 0.75,
    );
    petalPath.quadraticBezierTo(
      petalWidth * 0.5, -petalLength * 0.3,
      0, 0,
    );
    petalPath.close();
    
    final petalPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, -petalLength),
        [
          Color.lerp(secondaryColor, Colors.black, 0.1)!,
          primaryColor,
          Color.lerp(primaryColor, Colors.white, 0.18)!,
        ],
        [0.0, 0.5, 1.0],
      );
    
    canvas.drawPath(petalPath, petalPaint);
    canvas.restore();
  }

  void _draw3DRose(Canvas canvas, Offset center, double radius, Color primaryColor, Color secondaryColor, double rotation) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    
    // Draw strong shadow for 3D effect
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(radius * 0.05, radius * 0.05), radius * 0.9, shadowPaint);
    
    // Outer petals (largest, back layer)
    _drawRosePetalLayer(canvas, Offset(0, 0), radius * 0.95, primaryColor, secondaryColor, 8, 0.0);
    
    // Middle petals
    _drawRosePetalLayer(canvas, Offset(0, 0), radius * 0.75, primaryColor, secondaryColor, 6, 0.3);
    
    // Inner petals
    _drawRosePetalLayer(canvas, Offset(0, 0), radius * 0.55, primaryColor, secondaryColor, 5, 0.6);
    
    // Center spiral (rose center)
    _drawRoseCenter(canvas, Offset(0, 0), radius * 0.3, primaryColor, secondaryColor);
    
    canvas.restore();
  }

  void _drawRosePetalLayer(Canvas canvas, Offset center, double radius, Color primaryColor, Color secondaryColor, int petalCount, double angleOffset) {
    final angleStep = 2 * math.pi / petalCount;
    
    for (int i = 0; i < petalCount; i++) {
      final angle = i * angleStep + angleOffset;
      _drawCurledRosePetal(canvas, center, radius, angle, primaryColor, secondaryColor);
    }
  }

  void _drawCurledRosePetal(Canvas canvas, Offset center, double radius, double angle, Color primaryColor, Color secondaryColor) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    // Create curled petal shape
    final petalPath = Path();
    final width = radius * 0.6;
    final length = radius * 0.7;
    
    petalPath.moveTo(0, 0);
    petalPath.cubicTo(
      -width * 0.5, -length * 0.2,
      -width * 0.45, -length * 0.6,
      -width * 0.25, -length * 0.85,
    );
    petalPath.cubicTo(
      -width * 0.1, -length * 0.95,
      width * 0.1, -length * 0.95,
      width * 0.25, -length * 0.85,
    );
    petalPath.cubicTo(
      width * 0.45, -length * 0.6,
      width * 0.5, -length * 0.2,
      0, 0,
    );
    petalPath.close();
    
    // Strong shadow for depth
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(petalPath, shadowPaint);
    
    // Gradient from dark at base to light at tip
    final gradientPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, -length * 0.1),
        Offset(0, -length * 0.9),
        [
          Color.lerp(secondaryColor, Colors.black, 0.2)!,
          secondaryColor,
          primaryColor,
          Color.lerp(primaryColor, Colors.white, 0.2)!,
        ],
        [0.0, 0.3, 0.7, 1.0],
      );
    canvas.drawPath(petalPath, gradientPaint);
    
    // Highlight on edge for curl effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    final highlightPath = Path();
    highlightPath.moveTo(width * 0.2, -length * 0.8);
    highlightPath.quadraticBezierTo(
      width * 0.35, -length * 0.7,
      width * 0.4, -length * 0.4,
    );
    canvas.drawPath(highlightPath, highlightPaint);
    
    canvas.restore();
  }

  void _drawRoseCenter(Canvas canvas, Offset center, double radius, Color primaryColor, Color secondaryColor) {
    // Draw spiral center like a real rose
    final centerPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          Color.lerp(secondaryColor, Colors.black, 0.3)!,
          secondaryColor,
          primaryColor,
        ],
        [0.0, 0.5, 1.0],
      );
    
    // Draw spiral petals in center
    final spiralCount = 3;
    for (int i = 0; i < spiralCount; i++) {
      final spiralRadius = radius * (1 - i * 0.25);
      final angle = i * 2.0;
      
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      
      final spiralPath = Path();
      spiralPath.moveTo(0, 0);
      spiralPath.quadraticBezierTo(
        -spiralRadius * 0.4, -spiralRadius * 0.3,
        -spiralRadius * 0.3, -spiralRadius * 0.7,
      );
      spiralPath.quadraticBezierTo(
        0, -spiralRadius,
        spiralRadius * 0.3, -spiralRadius * 0.7,
      );
      spiralPath.quadraticBezierTo(
        spiralRadius * 0.4, -spiralRadius * 0.3,
        0, 0,
      );
      spiralPath.close();
      
      canvas.drawPath(spiralPath, centerPaint);
      canvas.restore();
    }
    
    // Dark center point
    final centerDotPaint = Paint()
      ..color = Color.lerp(secondaryColor, Colors.black, 0.5)!;
    canvas.drawCircle(center, radius * 0.2, centerDotPaint);
  }


  List<Map<String, Color>> _generateColorVariations(
    Color primaryColor,
    Color secondaryColor,
    math.Random random,
  ) {
    final variations = <Map<String, Color>>[];
    
    // Original colors
    variations.add({
      'primary': primaryColor,
      'secondary': secondaryColor,
    });
    
    // Lighter variation
    variations.add({
      'primary': _adjustColorBrightness(primaryColor, 1.2),
      'secondary': _adjustColorBrightness(secondaryColor, 1.15),
    });
    
    // Darker variation
    variations.add({
      'primary': _adjustColorBrightness(primaryColor, 0.85),
      'secondary': _adjustColorBrightness(secondaryColor, 0.9),
    });
    
    // Slightly shifted hue
    variations.add({
      'primary': _shiftHue(primaryColor, 15),
      'secondary': _shiftHue(secondaryColor, 15),
    });
    
    // Another hue shift
    variations.add({
      'primary': _shiftHue(primaryColor, -15),
      'secondary': _shiftHue(secondaryColor, -15),
    });
    
    return variations;
  }

  Color _adjustColorBrightness(Color color, double factor) {
    return Color.fromARGB(
      color.alpha,
      (color.red * factor).clamp(0, 255).toInt(),
      (color.green * factor).clamp(0, 255).toInt(),
      (color.blue * factor).clamp(0, 255).toInt(),
    );
  }

  Color _shiftHue(Color color, double degrees) {
    final hslColor = HSLColor.fromColor(color);
    final newHue = (hslColor.hue + degrees) % 360;
    return hslColor.withHue(newHue).toColor();
  }


  @override
  bool shouldRepaint(FlowerPainter oldDelegate) {
    return oldDelegate.flowerMon.id != flowerMon.id ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.animationStyle != animationStyle;
  }
}
