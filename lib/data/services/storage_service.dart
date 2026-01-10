import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flower_mon.dart';

class StorageService {
  static const String _todayKey = 'todayFlowerMon';
  static const String _collectionKey = 'flowerMonCollection';
  static const String _recipientNameKey = 'recipientName';
  static const String _notificationHourKey = 'notificationHour';
  static const String _notificationMinuteKey = 'notificationMinute';

  late SharedPreferences _prefs;

  Future<void> init() async {
    await Hive.initFlutter();
    _prefs = await SharedPreferences.getInstance();
  }

  // Today's Flower-Mon
  FlowerMon? getTodayFlowerMon() {
    final jsonStr = _prefs.getString(_todayKey);
    if (jsonStr == null) return null;
    try {
      return FlowerMon.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveTodayFlowerMon(FlowerMon flowerMon) async {
    await _prefs.setString(_todayKey, jsonEncode(flowerMon.toJson()));
    // Also add to collection
    await addToCollection(flowerMon);
  }

  // Collection (FlowerDex)
  Future<void> addToCollection(FlowerMon flowerMon) async {
    final collectionJson = _prefs.getString(_collectionKey);
    Map<String, dynamic> collection;
    if (collectionJson != null) {
      collection = jsonDecode(collectionJson) as Map<String, dynamic>;
    } else {
      collection = {};
    }
    collection[flowerMon.id] = flowerMon.toJson();
    await _prefs.setString(_collectionKey, jsonEncode(collection));
  }

  List<FlowerMon> getAllFlowerMons() {
    final collectionJson = _prefs.getString(_collectionKey);
    if (collectionJson == null) return [];
    
    try {
      final collection = jsonDecode(collectionJson) as Map<String, dynamic>;
      final all = <FlowerMon>[];
      for (final entry in collection.entries) {
        try {
          final flowerMon = FlowerMon.fromJson(entry.value as Map<String, dynamic>);
          all.add(flowerMon);
        } catch (e) {
          // Skip invalid entries
        }
      }
      // Sort by date (newest first)
      all.sort((a, b) => b.dateGenerated.compareTo(a.dateGenerated));
      return all;
    } catch (e) {
      return [];
    }
  }

  FlowerMon? getFlowerMonById(String id) {
    final collectionJson = _prefs.getString(_collectionKey);
    if (collectionJson == null) return null;
    
    try {
      final collection = jsonDecode(collectionJson) as Map<String, dynamic>;
      final json = collection[id];
      if (json == null) return null;
      return FlowerMon.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  int getCollectionCount() {
    return getAllFlowerMons().length;
  }

  // Preferences
  String? getRecipientName() {
    return _prefs.getString(_recipientNameKey);
  }

  Future<void> setRecipientName(String name) async {
    await _prefs.setString(_recipientNameKey, name);
  }

  int getNotificationHour() {
    return _prefs.getInt(_notificationHourKey) ?? 8; // Default 8 AM
  }

  Future<void> setNotificationHour(int hour) async {
    await _prefs.setInt(_notificationHourKey, hour);
  }

  int getNotificationMinute() {
    return _prefs.getInt(_notificationMinuteKey) ?? 0; // Default :00
  }

  Future<void> setNotificationMinute(int minute) async {
    await _prefs.setInt(_notificationMinuteKey, minute);
  }

  Future<void> clearAllData() async {
    await _prefs.remove(_todayKey);
    await _prefs.remove(_collectionKey);
    await _prefs.remove(_recipientNameKey);
    await _prefs.remove(_notificationHourKey);
    await _prefs.remove(_notificationMinuteKey);
  }
}
