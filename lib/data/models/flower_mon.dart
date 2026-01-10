import 'package:hive/hive.dart';

enum FlowerMonType {
  grass,
  @HiveField(1)
  fire,
  @HiveField(2)
  water,
  @HiveField(3)
  electric,
  @HiveField(4)
  fairy,
  @HiveField(5)
  mystic,
  @HiveField(6)
  air,
  @HiveField(7)
  shadow;

  String get displayName {
    switch (this) {
      case FlowerMonType.grass:
        return 'Grass';
      case FlowerMonType.fire:
        return 'Fire';
      case FlowerMonType.water:
        return 'Water';
      case FlowerMonType.electric:
        return 'Electric';
      case FlowerMonType.fairy:
        return 'Fairy';
      case FlowerMonType.mystic:
        return 'Mystic';
      case FlowerMonType.air:
        return 'Air';
      case FlowerMonType.shadow:
        return 'Shadow';
    }
  }

  String get emoji {
    switch (this) {
      case FlowerMonType.grass:
        return '🌿';
      case FlowerMonType.fire:
        return '🔥';
      case FlowerMonType.water:
        return '💧';
      case FlowerMonType.electric:
        return '⚡';
      case FlowerMonType.fairy:
        return '✨';
      case FlowerMonType.mystic:
        return '🔮';
      case FlowerMonType.air:
        return '💨';
      case FlowerMonType.shadow:
        return '🌙';
    }
  }
}

enum FlowerMonRarity {
  common,
  rare,
  epic,
  legendary;

  String get displayName {
    switch (this) {
      case FlowerMonRarity.common:
        return 'Common';
      case FlowerMonRarity.rare:
        return 'Rare';
      case FlowerMonRarity.epic:
        return 'Epic';
      case FlowerMonRarity.legendary:
        return 'Legendary';
    }
  }

  double get spawnChance {
    switch (this) {
      case FlowerMonRarity.common:
        return 0.70; // 70%
      case FlowerMonRarity.rare:
        return 0.25; // 25%
      case FlowerMonRarity.epic:
        return 0.045; // 4.5%
      case FlowerMonRarity.legendary:
        return 0.005; // 0.5%
    }
  }
}

enum PetalShape {
  round,
  pointed,
  heart,
  star,
  droplet;

  String get displayName {
    switch (this) {
      case PetalShape.round:
        return 'Round';
      case PetalShape.pointed:
        return 'Pointed';
      case PetalShape.heart:
        return 'Heart';
      case PetalShape.star:
        return 'Star';
      case PetalShape.droplet:
        return 'Droplet';
    }
  }
}

enum CenterDesign {
  simple,
  spiraled,
  layered,
  crystalline;

  String get displayName {
    switch (this) {
      case CenterDesign.simple:
        return 'Simple';
      case CenterDesign.spiraled:
        return 'Spiraled';
      case CenterDesign.layered:
        return 'Layered';
      case CenterDesign.crystalline:
        return 'Crystalline';
    }
  }
}

enum FlowerMonAnimationStyle {
  gentleBreathe,
  slowSway,
  softPulse,
  calmGlow;

  String get displayName {
    switch (this) {
      case FlowerMonAnimationStyle.gentleBreathe:
        return 'Gentle Breathe';
      case FlowerMonAnimationStyle.slowSway:
        return 'Slow Sway';
      case FlowerMonAnimationStyle.softPulse:
        return 'Soft Pulse';
      case FlowerMonAnimationStyle.calmGlow:
        return 'Calm Glow';
    }
  }
}

class FlowerMon {
  final String id;
  final String name;
  final FlowerMonType type;
  final FlowerMonRarity rarity;
  final int primaryColorValue;
  final int secondaryColorValue;
  final PetalShape petalShape;
  final CenterDesign centerDesign;
  final FlowerMonAnimationStyle animationStyle;
  final String romanticMessage;
  final DateTime dateGenerated;

  FlowerMon({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    required this.primaryColorValue,
    required this.secondaryColorValue,
    required this.petalShape,
    required this.centerDesign,
    required this.animationStyle,
    required this.romanticMessage,
    required this.dateGenerated,
  });

  // Getter for primary color
  int get primaryColor => primaryColorValue;

  // Getter for secondary color
  int get secondaryColor => secondaryColorValue;

  String get typeEmoji => type.emoji;
  String get typeName => type.displayName;
  String get rarityName => rarity.displayName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'rarity': rarity.name,
        'primaryColorValue': primaryColorValue,
        'secondaryColorValue': secondaryColorValue,
        'petalShape': petalShape.name,
        'centerDesign': centerDesign.name,
        'animationStyle': animationStyle.name,
        'romanticMessage': romanticMessage,
        'dateGenerated': dateGenerated.toIso8601String(),
      };

  factory FlowerMon.fromJson(Map<String, dynamic> json) => FlowerMon(
        id: json['id'] as String,
        name: json['name'] as String,
        type: FlowerMonType.values.firstWhere(
          (e) => e.name == json['type'],
        ),
        rarity: FlowerMonRarity.values.firstWhere(
          (e) => e.name == json['rarity'],
        ),
        primaryColorValue: json['primaryColorValue'] as int,
        secondaryColorValue: json['secondaryColorValue'] as int,
        petalShape: PetalShape.values.firstWhere(
          (e) => e.name == json['petalShape'],
        ),
        centerDesign: CenterDesign.values.firstWhere(
          (e) => e.name == json['centerDesign'],
        ),
        animationStyle: FlowerMonAnimationStyle.values.firstWhere(
          (e) => e.name == json['animationStyle'],
        ),
        romanticMessage: json['romanticMessage'] as String,
        dateGenerated: DateTime.parse(json['dateGenerated'] as String),
      );
}
