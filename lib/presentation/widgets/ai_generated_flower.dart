import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/flower_mon.dart';

/// Displays AI-generated flower images using Pollinations.ai API
class AIGeneratedFlower extends StatefulWidget {
  final FlowerMon flowerMon;
  final double size;

  const AIGeneratedFlower({
    super.key,
    required this.flowerMon,
    required this.size,
  });

  @override
  State<AIGeneratedFlower> createState() => _AIGeneratedFlowerState();
}

class _AIGeneratedFlowerState extends State<AIGeneratedFlower>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? _previousImageUrl;
  bool _isFirstLoad = true;

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

  @override
  void didUpdateWidget(AIGeneratedFlower oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Store previous image URL when FlowerMon changes
    if (oldWidget.flowerMon.id != widget.flowerMon.id) {
      // Generate URL for OLD widget before it changes
      _previousImageUrl = _getAIImageUrlForFlower(oldWidget.flowerMon);
      _isFirstLoad = false;
    }
  }

  /// Generate AI prompt based on FlowerMon properties
  String _generateFlowerPromptForFlower(FlowerMon flowerMon) {
    // Get flower characteristics
    final petalType = _getPetalDescriptionFor(flowerMon);
    final colorDesc = _getColorDescriptionFor(flowerMon);
    final rarityDesc = _getRarityDescriptionFor(flowerMon);
    final typeDesc = _getTypeDescriptionFor(flowerMon);
    
    // Create detailed prompt for AI - emphasizing bouquet/buffet
    return 'A stunning, photorealistic close-up of a lush, abundant buffet bouquet of beautiful $rarityDesc $petalType flowers, '
           'multiple blooms clustered together, $colorDesc colors, $typeDesc style, '
           'overflowing floral arrangement, densely packed flowers, professional photography, '
           'soft natural lighting, botanical garden quality, high detail, '
           'centered composition, blurred background, artistic, elegant, full frame composition';
  }

  String _getPetalDescriptionFor(FlowerMon flowerMon) {
    switch (flowerMon.petalShape) {
      case PetalShape.round:
        return 'round-petaled daisy-like';
      case PetalShape.pointed:
        return 'pointed elegant lily-like';
      case PetalShape.heart:
        return 'romantic rose-like';
      case PetalShape.star:
        return 'star-shaped exotic';
      case PetalShape.droplet:
        return 'delicate lotus-like';
    }
  }

  String _getColorDescriptionFor(FlowerMon flowerMon) {
    final primaryColor = Color(flowerMon.primaryColor);
    final secondaryColor = Color(flowerMon.secondaryColor);
    
    // Convert colors to descriptive names
    String primaryName = _getColorName(primaryColor);
    String secondaryName = _getColorName(secondaryColor);
    
    return '$primaryName and $secondaryName gradient';
  }

  String _getColorName(Color color) {
    final hue = HSLColor.fromColor(color).hue;
    final lightness = HSLColor.fromColor(color).lightness;
    
    if (lightness > 0.9) return 'white';
    if (lightness < 0.2) return 'deep black';
    
    if (hue < 15 || hue > 345) return lightness > 0.6 ? 'pink' : 'red';
    if (hue < 45) return lightness > 0.6 ? 'peach' : 'orange';
    if (hue < 75) return 'yellow';
    if (hue < 150) return lightness > 0.6 ? 'mint' : 'green';
    if (hue < 200) return 'cyan';
    if (hue < 260) return lightness > 0.6 ? 'lavender' : 'blue';
    if (hue < 290) return lightness > 0.6 ? 'violet' : 'purple';
    return lightness > 0.6 ? 'magenta' : 'burgundy';
  }

  String _getRarityDescriptionFor(FlowerMon flowerMon) {
    switch (flowerMon.rarity) {
      case FlowerMonRarity.common:
        return 'vibrant';
      case FlowerMonRarity.rare:
        return 'exotic rare';
      case FlowerMonRarity.epic:
        return 'magnificent epic';
      case FlowerMonRarity.legendary:
        return 'legendary mystical glowing';
    }
  }

  String _getTypeDescriptionFor(FlowerMon flowerMon) {
    switch (flowerMon.type) {
      case FlowerMonType.grass:
        return 'natural garden';
      case FlowerMonType.fire:
        return 'fiery warm-toned';
      case FlowerMonType.water:
        return 'aquatic serene';
      case FlowerMonType.electric:
        return 'luminous electric';
      case FlowerMonType.fairy:
        return 'magical ethereal';
      case FlowerMonType.mystic:
        return 'mystical enchanted';
      case FlowerMonType.air:
        return 'light airy';
      case FlowerMonType.shadow:
        return 'dark mysterious';
    }
  }

  /// Get AI-generated image URL using multiple free APIs
  String _getAIImageUrl() {
    return _getAIImageUrlForFlower(widget.flowerMon);
  }

  String _getAIImageUrlForFlower(FlowerMon flowerMon) {
    final prompt = _generateFlowerPromptForFlower(flowerMon);
    final seed = flowerMon.id.hashCode.abs();
    final encodedPrompt = Uri.encodeComponent(prompt);
    
    // Try multiple free AI image generation APIs
    // 1. Pollinations.ai - Free, unlimited
    // 2. Hugging Face Inference API - Free tier available
    // 3. Replicate via Pollinations proxy
    
    // Using Pollinations.ai with model selection for better quality
    // They proxy to multiple models including Flux, SDXL, etc.
    final imageUrl = 'https://image.pollinations.ai/prompt/$encodedPrompt?seed=$seed&width=1440&height=1440&nologo=true&enhance=true&model=flux';
    
    // Log the request details
    if (kDebugMode) {
      print('═══════════════════════════════════════════════════════════');
      print('🌸 AI FLOWER GENERATION REQUEST');
      print('═══════════════════════════════════════════════════════════');
      print('FlowerMon ID: ${flowerMon.id}');
      print('FlowerMon Name: ${flowerMon.name}');
      print('Petal Shape: ${flowerMon.petalShape}');
      print('Rarity: ${flowerMon.rarity}');
      print('Type: ${flowerMon.type}');
      print('Primary Color: #${flowerMon.primaryColor.toRadixString(16).padLeft(8, '0')}');
      print('Secondary Color: #${flowerMon.secondaryColor.toRadixString(16).padLeft(8, '0')}');
      print('───────────────────────────────────────────────────────────');
      print('Seed: $seed');
      print('───────────────────────────────────────────────────────────');
      print('AI Prompt:');
      print(prompt);
      print('───────────────────────────────────────────────────────────');
      print('Full Image URL:');
      print(imageUrl);
      print('═══════════════════════════════════════════════════════════\n');
    }
    
    return imageUrl;
  }

  /// Generate flower history/definition based on type and characteristics
  String _getFlowerHistory() {
    // Base description on flower type
    String history = '';
    
    switch (widget.flowerMon.type) {
      case FlowerMonType.grass:
        history = 'In ancient gardens, these vibrant blooms were said to bring life and renewal to all who beheld them. '
                  'Their lush petals symbolize growth, harmony with nature, and the endless cycle of seasons.';
        break;
      case FlowerMonType.fire:
        history = 'Legends speak of these rare flowers blooming only in the warmth of true passion. '
                  'Their fiery colors represent courage, desire, and an unquenchable flame that burns eternal.';
        break;
      case FlowerMonType.water:
        history = 'Born from crystalline waters, these delicate flowers have graced sacred springs for millennia. '
                  'They embody serenity, emotional depth, and the flowing nature of pure, unconditional love.';
        break;
      case FlowerMonType.electric:
        history = 'Rare and electrifying, these blooms appear only during mystical storms. '
                  'They symbolize excitement, energy, and the spark that ignites when two souls connect.';
        break;
      case FlowerMonType.fairy:
        history = 'Tales tell of fairy gardens where these enchanted flowers bloom under moonlight. '
                  'They represent magic, wonder, and the delicate beauty of dreams coming true.';
        break;
      case FlowerMonType.mystic:
        history = 'Ancient mystics cultivated these flowers in sacred temples, believing they held cosmic wisdom. '
                  'They symbolize mystery, spiritual connection, and the profound bond between kindred spirits.';
        break;
      case FlowerMonType.air:
        history = 'These ethereal flowers dance on gentle breezes, never touching the ground. '
                  'They represent freedom, lightness of spirit, and love that lifts you higher than the clouds.';
        break;
      case FlowerMonType.shadow:
        history = 'Blooming only in twilight, these mysterious flowers are as rare as they are beautiful. '
                  'They symbolize the beauty in darkness, the strength in vulnerability, and love that endures through any trial.';
        break;
    }
    
    return history;
  }

  /// Generate romantic message relating the flower to love
  String _getRomanticMessage() {
    final rarityMessages = {
      FlowerMonRarity.common: 'Like this beautiful bloom, our love blossoms fresh and vibrant every single day.',
      FlowerMonRarity.rare: 'Just as this rare flower is one in a thousand, you are irreplaceable in my heart.',
      FlowerMonRarity.epic: 'This magnificent flower reminds me that our love is truly epic—a once-in-a-lifetime treasure.',
      FlowerMonRarity.legendary: 'Like this legendary bloom, our love is the stuff of myths—timeless, magical, and absolutely extraordinary.',
    };
    
    final typeMessages = {
      FlowerMonType.grass: ' You bring life and color to my world, making every moment with you feel like spring.',
      FlowerMonType.fire: ' My love for you burns with the same intensity as this flower\'s brilliant hues.',
      FlowerMonType.water: ' Like gentle waves, my feelings for you flow endlessly, deep and serene.',
      FlowerMonType.electric: ' You electrify my heart, making every moment together spark with joy.',
      FlowerMonType.fairy: ' With you, every day feels magical, as if we\'re living in our own fairy tale.',
      FlowerMonType.mystic: ' Our connection transcends words—a mystical bond that grows stronger with each passing day.',
      FlowerMonType.air: ' You lift my spirit and make me feel free, like I could float on clouds with you forever.',
      FlowerMonType.shadow: ' Even in darkness, your love is my guiding light, my strength, my everything.',
    };
    
    return rarityMessages[widget.flowerMon.rarity]! + typeMessages[widget.flowerMon.type]!;
  }

  /// Show flower story dialog
  void _showFlowerStoryDialog(BuildContext context) {
    final combinedMessage = '${_getFlowerHistory()}\n\n${_getRomanticMessage()}';
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20), // Wider dialog
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient:const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
               Color(0xFFF0AF1D),
                Color(0xFFF0AF1D),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(widget.flowerMon.primaryColor).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Flower icon
                Icon(
                  Icons.local_florist,
                  size: 50,
                  color: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(height: 12),
                
                // Flower name
                Text(
                  widget.flowerMon.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 20),
                
                // Combined message (legend + romance)
                Text(
                  combinedMessage,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 15,
                    height: 1.7,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.justify,
                ),
                
                const SizedBox(height: 24),
                
                // Close button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get actual screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return GestureDetector(
      onDoubleTap: () => _showFlowerStoryDialog(context),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final breatheScale = 1.0 + (math.sin(_controller.value * 2 * math.pi) * 0.01);
          
          return Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(widget.flowerMon.primaryColor).withOpacity(0.3),
                Color(widget.flowerMon.secondaryColor).withOpacity(0.3),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Full screen background image
              Positioned.fill(
                child: Transform.scale(
                  scale: breatheScale,
                  child: CachedNetworkImage(
                    imageUrl: _getAIImageUrl(),
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: screenHeight,
                    imageBuilder: (context, imageProvider) {
                      // Log successful image load
                      if (kDebugMode) {
                        print('✅ SUCCESS: AI Flower image loaded successfully');
                        print('   FlowerMon: ${widget.flowerMon.name}');
                        print('   Screen Size: ${screenWidth}x$screenHeight');
                        print('   Image URL: ${_getAIImageUrl()}');
                        print('   Image cached locally: Yes');
                        print('───────────────────────────────────────────────────────────\n');
                      }
                      
                      return Container(
                        width: screenWidth,
                        height: screenHeight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      // Log loading state
                      if (kDebugMode) {
                        print('⏳ LOADING: Fetching AI flower image...');
                        print('   URL: $url');
                        print('   Showing previous image: ${_previousImageUrl != null}');
                        print('───────────────────────────────────────────────────────────');
                      }
                      
                      // Show previous image while loading new one (seamless transition)
                      if (_previousImageUrl != null && !_isFirstLoad) {
                        return Container(
                          width: screenWidth,
                          height: screenHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(_previousImageUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(0.1), // Subtle overlay to indicate loading
                          ),
                        );
                      }
                      
                      // First load - show gradient with loading indicator
                      return Container(
                        width: screenWidth,
                        height: screenHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(widget.flowerMon.primaryColor).withOpacity(0.4),
                              Color(widget.flowerMon.secondaryColor).withOpacity(0.4),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 4,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                '🌸 Creating Your Flower 🌸',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Powered by AI',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      // Log error details
                      if (kDebugMode) {
                        print('❌ ERROR: Failed to load AI flower image');
                        print('═══════════════════════════════════════════════════════════');
                        print('FlowerMon: ${widget.flowerMon.name}');
                        print('URL: $url');
                        print('───────────────────────────────────────────────────────────');
                        print('Error Type: ${error.runtimeType}');
                        print('Error Message: $error');
                        print('───────────────────────────────────────────────────────────');
                        print('Stack Trace:');
                        print(StackTrace.current);
                        print('═══════════════════════════════════════════════════════════\n');
                      }
                      return Container(
                        width: screenWidth,
                        height: screenHeight,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_florist,
                                size: 140,
                                color: Colors.white70,
                              ),
                              SizedBox(height: 24),
                              Text(
                                'Mystical Flower',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            ],
          ),
        );
      },
      ),
    );
  }

}
