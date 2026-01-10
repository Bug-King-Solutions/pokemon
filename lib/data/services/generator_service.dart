import 'dart:math';
import '../models/flower_mon.dart';

class GeneratorService {
  GeneratorService();

  /// Generate a Flower-Mon deterministically based on a date
  FlowerMon generateForDate(DateTime date) {
    // Create a deterministic seed from the date (same date = same Flower-Mon)
    final dateSeed = DateTime(date.year, date.month, date.day);
    final seed = dateSeed.millisecondsSinceEpoch;
    final random = Random(seed);

    // Generate rarity (weighted)
    final rarity = _generateRarity(random);

    // Generate type
    final type = _generateType(random, rarity);

    // Generate colors based on type
    final colors = _generateColors(type, random);

    // Generate petal shape
    final petalShape = _generatePetalShape(random, rarity);

    // Generate center design
    final centerDesign = _generateCenterDesign(random, rarity);

    // Generate animation style
    final animationStyle = _generateFlowerMonAnimationStyle(random, type);

    // Generate name
    final name = _generateName(type, rarity, random);

    // Generate romantic message
    final romanticMessage = _generateRomanticMessage(type, rarity, random);

    // Create unique ID from date
    final id = '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';

    return FlowerMon(
      id: id,
      name: name,
      type: type,
      rarity: rarity,
      primaryColorValue: colors['primary']!,
      secondaryColorValue: colors['secondary']!,
      petalShape: petalShape,
      centerDesign: centerDesign,
      animationStyle: animationStyle,
      romanticMessage: romanticMessage,
      dateGenerated: date,
    );
  }

  FlowerMonRarity _generateRarity(Random random) {
    final roll = random.nextDouble();
    double cumulative = 0;

    for (final rarity in FlowerMonRarity.values.reversed) {
      cumulative += rarity.spawnChance;
      if (roll <= cumulative) {
        return rarity;
      }
    }

    return FlowerMonRarity.common;
  }

  FlowerMonType _generateType(Random random, FlowerMonRarity rarity) {
    // Legendary types have preferences
    if (rarity == FlowerMonRarity.legendary) {
      final legendaryTypes = [
        FlowerMonType.mystic,
        FlowerMonType.shadow,
        FlowerMonType.fairy,
      ];
      return legendaryTypes[random.nextInt(legendaryTypes.length)];
    }

    return FlowerMonType.values[random.nextInt(FlowerMonType.values.length)];
  }

  Map<String, int> _generateColors(FlowerMonType type, Random random) {
    // Type-based color palettes
    final palettes = {
      FlowerMonType.grass: [
        {'primary': 0xFFA8E6CF, 'secondary': 0xFF8DD9B8},
        {'primary': 0xFFB5E8D3, 'secondary': 0xFF7DD9B3},
        {'primary': 0xFF9FE6C7, 'secondary': 0xFF6ED9A6},
      ],
      FlowerMonType.fire: [
        {'primary': 0xFFFFB6B9, 'secondary': 0xFFFF9A9E},
        {'primary': 0xFFFFC5C8, 'secondary': 0xFFFF8A8F},
        {'primary': 0xFFFFADB0, 'secondary': 0xFFFF7A80},
      ],
      FlowerMonType.water: [
        {'primary': 0xFFB4D9F5, 'secondary': 0xFF9BC8F0},
        {'primary': 0xFFC5E3F8, 'secondary': 0xFF8BC2EB},
        {'primary': 0xFFAAD5F3, 'secondary': 0xFF7BB8E8},
      ],
      FlowerMonType.electric: [
        {'primary': 0xFFFFF4A3, 'secondary': 0xFFFFEB8A},
        {'primary': 0xFFFFF9B8, 'secondary': 0xFFFFE575},
        {'primary': 0xFFFFF7AE, 'secondary': 0xFFFFE260},
      ],
      FlowerMonType.fairy: [
        {'primary': 0xFFF6C1CC, 'secondary': 0xFFF2A9B9},
        {'primary': 0xFFF8CCD5, 'secondary': 0xFFEF9FB2},
        {'primary': 0xFFF4B7C4, 'secondary': 0xFFEC95AB},
      ],
      FlowerMonType.mystic: [
        {'primary': 0xFFC7B9FF, 'secondary': 0xFFB19FFF},
        {'primary': 0xFFD3C7FF, 'secondary': 0xFFA595FF},
        {'primary': 0xFFCCC0FF, 'secondary': 0xFFAD9BFF},
      ],
      FlowerMonType.air: [
        {'primary': 0xFFE0E7FF, 'secondary': 0xFFD1DBFF},
        {'primary': 0xFFE8EDFF, 'secondary': 0xFFC9D5FF},
        {'primary': 0xFFE4EBFF, 'secondary': 0xFFCDD9FF},
      ],
      FlowerMonType.shadow: [
        {'primary': 0xFFB8A9C9, 'secondary': 0xFFA896C0},
        {'primary': 0xFFC2B5D2, 'secondary': 0xFFA28FB8},
        {'primary': 0xFFBDB0CB, 'secondary': 0xFF9E8AB4},
      ],
    };

    final palette = palettes[type]!;
    return palette[random.nextInt(palette.length)];
  }

  PetalShape _generatePetalShape(Random random, FlowerMonRarity rarity) {
    final shapes = PetalShape.values;
    
    // Higher rarity = more unique shapes
    if (rarity == FlowerMonRarity.legendary) {
      final legendaryShapes = [PetalShape.star, PetalShape.heart];
      return legendaryShapes[random.nextInt(legendaryShapes.length)];
    } else if (rarity == FlowerMonRarity.epic) {
      final epicShapes = [PetalShape.star, PetalShape.heart, PetalShape.droplet];
      return epicShapes[random.nextInt(epicShapes.length)];
    }

    return shapes[random.nextInt(shapes.length)];
  }

  CenterDesign _generateCenterDesign(Random random, FlowerMonRarity rarity) {
    final designs = CenterDesign.values;
    
    // Higher rarity = more complex designs
    if (rarity == FlowerMonRarity.legendary) {
      return CenterDesign.crystalline;
    } else if (rarity == FlowerMonRarity.epic) {
      final epicDesigns = [CenterDesign.layered, CenterDesign.crystalline];
      return epicDesigns[random.nextInt(epicDesigns.length)];
    } else if (rarity == FlowerMonRarity.rare) {
      final rareDesigns = [CenterDesign.spiraled, CenterDesign.layered];
      return rareDesigns[random.nextInt(rareDesigns.length)];
    }

    return designs[random.nextInt(designs.length)];
  }

  FlowerMonAnimationStyle _generateFlowerMonAnimationStyle(Random random, FlowerMonType type) {
    // Type-based animation preferences
    final styleMap = {
      FlowerMonType.grass: [FlowerMonAnimationStyle.gentleBreathe, FlowerMonAnimationStyle.slowSway],
      FlowerMonType.fire: [FlowerMonAnimationStyle.softPulse, FlowerMonAnimationStyle.calmGlow],
      FlowerMonType.water: [FlowerMonAnimationStyle.slowSway, FlowerMonAnimationStyle.gentleBreathe],
      FlowerMonType.electric: [FlowerMonAnimationStyle.calmGlow, FlowerMonAnimationStyle.softPulse],
      FlowerMonType.fairy: [FlowerMonAnimationStyle.gentleBreathe, FlowerMonAnimationStyle.calmGlow],
      FlowerMonType.mystic: [FlowerMonAnimationStyle.calmGlow, FlowerMonAnimationStyle.softPulse],
      FlowerMonType.air: [FlowerMonAnimationStyle.slowSway, FlowerMonAnimationStyle.gentleBreathe],
      FlowerMonType.shadow: [FlowerMonAnimationStyle.calmGlow, FlowerMonAnimationStyle.gentleBreathe],
    };

    final styles = styleMap[type]!;
    return styles[random.nextInt(styles.length)];
  }

  String _generateName(FlowerMonType type, FlowerMonRarity rarity, Random random) {
    final prefixes = {
      FlowerMonType.grass: ['Bloom', 'Pet', 'Verd', 'Moss', 'Leaf'],
      FlowerMonType.fire: ['Ember', 'Flame', 'Scorch', 'Blaze', 'Spark'],
      FlowerMonType.water: ['Aqua', 'Ripple', 'Dew', 'Cascade', 'Wave'],
      FlowerMonType.electric: ['Zap', 'Shock', 'Bolt', 'Spark', 'Flash'],
      FlowerMonType.fairy: ['Fairy', 'Glow', 'Sparkle', 'Twinkle', 'Shine'],
      FlowerMonType.mystic: ['Myst', 'Ench', 'Arc', 'Magic', 'Mystic'],
      FlowerMonType.air: ['Zeph', 'Breeze', 'Gust', 'Wind', 'Airy'],
      FlowerMonType.shadow: ['Moon', 'Star', 'Night', 'Dusk', 'Shadow'],
    };

    final suffixes = {
      FlowerMonRarity.common: ['bloom', 'petal', 'bud', 'blossom'],
      FlowerMonRarity.rare: ['rose', 'lily', 'orchid', 'daisy'],
      FlowerMonRarity.epic: ['princess', 'queen', 'noble', 'royal'],
      FlowerMonRarity.legendary: ['divine', 'celestial', 'eternal', 'legend'],
    };

    final prefixList = prefixes[type]!;
    final suffixList = suffixes[rarity]!;

    final prefix = prefixList[random.nextInt(prefixList.length)];
    final suffix = suffixList[random.nextInt(suffixList.length)];

    return '$prefix$suffix';
  }

  String _generateRomanticMessage(FlowerMonType type, FlowerMonRarity rarity, Random random) {
    final messages = {
      FlowerMonType.grass: [
        'Like a gentle breeze through leaves, may peace find you today.',
        'You bloom beautifully, just like this flower.',
        'Nature whispers: you are loved.',
        'May your day be as fresh as morning dew.',
      ],
      FlowerMonType.fire: [
        'Your passion lights up the world.',
        'Warmth and love surround you today.',
        'Like a gentle flame, your spirit inspires.',
        'May warmth always fill your heart.',
      ],
      FlowerMonType.water: [
        'Flowing like water, may serenity follow you.',
        'Your calm presence is a blessing.',
        'Like gentle waves, let peace wash over you.',
        'May tranquility fill your day.',
      ],
      FlowerMonType.electric: [
        'Your energy brightens every moment.',
        'Sparkle and shine, beautiful soul.',
        'Your light illuminates the path ahead.',
        'May excitement fill your day.',
      ],
      FlowerMonType.fairy: [
        'Magic follows wherever you go.',
        'You are enchanting, inside and out.',
        'May wonder fill your heart today.',
        'Like fairy dust, may joy sprinkle your day.',
      ],
      FlowerMonType.mystic: [
        'Mystery and magic dance around you.',
        'You see beauty others might miss.',
        'May enchantment fill your world.',
        'Your spirit is truly magical.',
      ],
      FlowerMonType.air: [
        'Light and free, may you soar today.',
        'Like a gentle breeze, may ease find you.',
        'Your lightness of being is inspiring.',
        'May freedom fill your heart.',
      ],
      FlowerMonType.shadow: [
        'In darkness, your light shines brightest.',
        'May peaceful rest find you tonight.',
        'Your depth and mystery are beautiful.',
        'Like moonlight, you illuminate the night.',
      ],
    };

    final messageList = messages[type]!;
    return messageList[random.nextInt(messageList.length)];
  }
}
