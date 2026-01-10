import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/app_update_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class UpdateService {
  // GitHub Releases Configuration
  // Replace these with your GitHub username and repository name
  // Example: username: 'yourusername', repo: 'pokemon'
  static const String _githubUsername = 'YOUR_GITHUB_USERNAME'; // TODO: Update this
  static const String _githubRepo = 'YOUR_REPO_NAME'; // TODO: Update this
  
  // GitHub Releases API endpoint
  static String get _updateCheckUrl => 
      'https://api.github.com/repos/$_githubUsername/$_githubRepo/releases/latest';
  
  static const String _lastUpdateCheckKey = 'last_update_check';
  static const String _dismissedVersionKey = 'dismissed_version';

  /// Check if an update is available
  Future<AppUpdateInfo?> checkForUpdate({
    bool forceCheck = false,
  }) async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

      // Get last check time to avoid too frequent checks
      final prefs = await SharedPreferences.getInstance();
      if (!forceCheck) {
        final lastCheck = prefs.getInt(_lastUpdateCheckKey);
        if (lastCheck != null) {
          final lastCheckTime = DateTime.fromMillisecondsSinceEpoch(lastCheck);
          final hoursSinceLastCheck = DateTime.now().difference(lastCheckTime).inHours;
          // Only check once per day
          if (hoursSinceLastCheck < 24) {
            return null;
          }
        }
      }

      // Check for update from server
      final response = await http.get(
        Uri.parse(_updateCheckUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Update check timeout');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Parse GitHub Releases format to our format
        AppUpdateInfo updateInfo;
        if (data.containsKey('tag_name')) {
          // GitHub Releases format
          final tagName = data['tag_name'] as String;
          final releaseNotes = data['body'] as String? ?? 'New update available!';
          
          // Find APK asset
          final assets = data['assets'] as List<dynamic>? ?? [];
          String? downloadUrl;
          for (var asset in assets) {
            final assetName = asset['browser_download_url'] as String? ?? '';
            if (assetName.endsWith('.apk')) {
              downloadUrl = assetName;
              break;
            }
          }
          
          if (downloadUrl == null) {
            throw Exception('No APK file found in release');
          }
          
          // Extract version code from tag (e.g., "v1.0.1" -> 1.0.1)
          final versionMatch = RegExp(r'v?(\d+)\.(\d+)\.(\d+)').firstMatch(tagName);
          int versionCode = 0;
          if (versionMatch != null) {
            final major = int.parse(versionMatch.group(1)!);
            final minor = int.parse(versionMatch.group(2)!);
            final patch = int.parse(versionMatch.group(3)!);
            versionCode = major * 10000 + minor * 100 + patch;
          }
          
          updateInfo = AppUpdateInfo(
            version: tagName.replaceFirst('v', ''),
            downloadUrl: downloadUrl,
            releaseNotes: releaseNotes,
            forceUpdate: false, // You can make pre-releases force updates if needed
            versionCode: versionCode,
          );
        } else {
          // Standard JSON format (custom API)
          updateInfo = AppUpdateInfo.fromJson(data);
        }

        // Save last check time
        await prefs.setInt(
          _lastUpdateCheckKey,
          DateTime.now().millisecondsSinceEpoch,
        );

        // Compare versions
        if (_isNewerVersion(updateInfo.version, currentVersion) ||
            updateInfo.versionCode > currentVersionCode) {
          // Check if user dismissed this version
          final dismissedVersion = prefs.getString(_dismissedVersionKey);
          if (dismissedVersion == updateInfo.version && !updateInfo.forceUpdate) {
            return null;
          }
          return updateInfo;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Update check error: $e');
      }
    }
    return null;
  }

  /// Compare version strings (e.g., "1.2.3" vs "1.2.4")
  bool _isNewerVersion(String newVersion, String currentVersion) {
    final newParts = newVersion.split('.').map(int.parse).toList();
    final currentParts = currentVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < newParts.length || i < currentParts.length; i++) {
      final newPart = i < newParts.length ? newParts[i] : 0;
      final currentPart = i < currentParts.length ? currentParts[i] : 0;

      if (newPart > currentPart) return true;
      if (newPart < currentPart) return false;
    }
    return false;
  }

  /// Download and install the update
  Future<void> downloadAndInstall(String downloadUrl) async {
    try {
      if (Platform.isAndroid) {
        // Request storage permission
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }

        // For Android, download APK and install
        final uri = Uri.parse(downloadUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('Could not launch download URL');
        }
      } else if (Platform.isIOS) {
        // For iOS, redirect to App Store or TestFlight
        final uri = Uri.parse(downloadUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('Could not launch App Store URL');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Download error: $e');
      }
      rethrow;
    }
  }

  /// Mark a version as dismissed
  Future<void> dismissVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dismissedVersionKey, version);
  }

  /// Get current app version info
  Future<Map<String, String>> getCurrentVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return {
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
      'packageName': packageInfo.packageName,
    };
  }
}
