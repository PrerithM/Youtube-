import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/channel.dart';

class FilterSettings {
  final List<Channel> allowedChannels;
  final bool isKidsMode;
  final String? parentalPin;
  final bool hideShorts;
  final bool hideTrending;

  const FilterSettings({
    required this.allowedChannels,
    required this.isKidsMode,
    this.parentalPin,
    required this.hideShorts,
    required this.hideTrending,
  });

  FilterSettings copyWith({
    List<Channel>? allowedChannels,
    bool? isKidsMode,
    String? parentalPin,
    bool? hideShorts,
    bool? hideTrending,
  }) {
    return FilterSettings(
      allowedChannels: allowedChannels ?? this.allowedChannels,
      isKidsMode: isKidsMode ?? this.isKidsMode,
      parentalPin: parentalPin ?? this.parentalPin,
      hideShorts: hideShorts ?? this.hideShorts,
      hideTrending: hideTrending ?? this.hideTrending,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowedChannels': allowedChannels.map((c) => c.toJson()).toList(),
      'isKidsMode': isKidsMode,
      'parentalPin': parentalPin,
      'hideShorts': hideShorts,
      'hideTrending': hideTrending,
    };
  }

  factory FilterSettings.fromJson(Map<String, dynamic> json) {
    return FilterSettings(
      allowedChannels: (json['allowedChannels'] as List<dynamic>?)
          ?.map((c) => Channel.fromJson(c))
          .toList() ?? [],
      isKidsMode: json['isKidsMode'] ?? false,
      parentalPin: json['parentalPin'],
      hideShorts: json['hideShorts'] ?? false,
      hideTrending: json['hideTrending'] ?? false,
    );
  }
}

class FilterProvider extends ChangeNotifier {
  static const String _settingsKey = 'filter_settings';
  
  FilterSettings _settings = const FilterSettings(
    allowedChannels: [],
    isKidsMode: false,
    hideShorts: false,
    hideTrending: false,
  );

  FilterSettings get settings => _settings;

  FilterProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      
      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson);
        _settings = FilterSettings.fromJson(settingsMap);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(_settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  Future<void> addChannel(Channel channel) async {
    final updatedChannels = List<Channel>.from(_settings.allowedChannels);
    
    // Check if channel already exists
    if (!updatedChannels.any((c) => c.id == channel.id)) {
      updatedChannels.add(channel);
      _settings = _settings.copyWith(allowedChannels: updatedChannels);
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> removeChannel(String channelId) async {
    final updatedChannels = _settings.allowedChannels
        .where((c) => c.id != channelId)
        .toList();
    
    _settings = _settings.copyWith(allowedChannels: updatedChannels);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> toggleKidsMode() async {
    _settings = _settings.copyWith(isKidsMode: !_settings.isKidsMode);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setParentalPin(String pin) async {
    _settings = _settings.copyWith(parentalPin: pin);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> toggleHideShorts() async {
    _settings = _settings.copyWith(hideShorts: !_settings.hideShorts);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> toggleHideTrending() async {
    _settings = _settings.copyWith(hideTrending: !_settings.hideTrending);
    await _saveSettings();
    notifyListeners();
  }

  bool isChannelAllowed(String channelId) {
    if (_settings.allowedChannels.isEmpty) return true;
    return _settings.allowedChannels.any((c) => c.id == channelId) ||
           getEducationalChannels().any((c) => c.id == channelId);
  }

  List<Channel> getEducationalChannels() {
    return const [
      Channel(
        id: 'UCbCmjCuTUZos6Inko4u57UQ',
        name: 'SciShow Kids',
        url: 'https://www.youtube.com/c/SciShowKids',
      ),
      Channel(
        id: 'UC4a-Gbdw7vOaccHmFo40b9g',
        name: 'Khan Academy',
        url: 'https://www.youtube.com/c/KhanAcademy',
      ),
      Channel(
        id: 'UCJ5v_MCY6GNUBTO8-D3XoAg',
        name: 'National Geographic Kids',
        url: 'https://www.youtube.com/c/NatGeoKids',
      ),
      Channel(
        id: 'UCsooa4yRKGN_zEE8iknghZA',
        name: 'Crash Course Kids',
        url: 'https://www.youtube.com/c/crashcoursekids',
      ),
      Channel(
        id: 'UCYO_jab_esuFRV4b17AJtAw',
        name: '3Blue1Brown',
        url: 'https://www.youtube.com/c/3blue1brown',
      ),
    ];
  }
}

