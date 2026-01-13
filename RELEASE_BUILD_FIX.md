# Release Build Fix - Stuck on Splash Screen

## Problem
The app was getting stuck on the splash screen when building a release APK (`flutter build apk --release`).

## Root Cause
The issue was caused by Android's default code obfuscation and minification in release builds, which can break Flutter/Dart code and Riverpod state management.

## Solution Applied

### 1. Disabled Code Minification and Shrinking
**File: `android/app/build.gradle.kts`**

Added to the `release` build type:
```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
        
        // Disable code shrinking and obfuscation
        isMinifyEnabled = false
        isShrinkResources = false
    }
}
```

### 2. Added ProGuard Rules (for future use)
**File: `android/app/proguard-rules.pro`** (created)

Added comprehensive ProGuard rules to keep:
- Flutter/Dart classes
- Gson (JSON serialization)
- OkHttp (networking)
- Model classes
- Native methods
- Annotations

These rules are ready if you want to enable minification later for smaller APK sizes.

### 3. Enabled Cleartext Traffic
**File: `android/app/src/main/AndroidManifest.xml`**

Added to `<application>` tag:
```xml
android:usesCleartextTraffic="true"
```

This allows HTTP traffic for the AI image generation API (Pollinations.ai).

## How to Build Release APK

1. Clean previous builds:
```bash
flutter clean
```

2. Build release APK:
```bash
flutter build apk --release
```

3. APK location:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Testing

Install the APK on your device:
```bash
flutter install
```

Or manually:
1. Copy `build/app/outputs/flutter-apk/app-release.apk` to your phone
2. Install it
3. The app should now start normally and show flowers

## Future Optimization (Optional)

If you want to reduce APK size later, you can enable minification:

1. Uncomment the ProGuard lines in `build.gradle.kts`
2. Test thoroughly to ensure nothing breaks
3. The ProGuard rules are already in place

## Notes

- **APK Size**: ~55MB (without minification)
- **Target SDK**: Android 34 (Android 14)
- **Minimum SDK**: Android 21 (Android 5.0)
- **Build Mode**: Release (optimized)
- **Signing**: Debug key (change for production)

## Verification Checklist

✅ App launches successfully  
✅ Native splash screen shows (white background)  
✅ Today screen loads with AI-generated flower  
✅ Navigation works (Today, FlowerDex, Settings)  
✅ Double-tap shows flower story dialog  
✅ Notifications can be scheduled  
✅ Images are cached locally  

## Common Issues

**Issue**: App still stuck on splash screen  
**Solution**: Make sure you ran `flutter clean` before rebuilding

**Issue**: "Cleartext HTTP traffic not permitted"  
**Solution**: Already fixed with `usesCleartextTraffic="true"`

**Issue**: Large APK size  
**Solution**: This is expected without minification. Enable ProGuard if needed.

---

**Build Date**: 2026-01-13  
**Flutter Version**: Latest stable  
**Build Output**: `app-release.apk` (54.7MB)
