import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsService extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _dynamicModeKey = 'dynamic_mode';
  static const String _darkModeKey = 'dark_mode';

  Box? _settingsBox;
  bool _dynamicMode = true;
  bool? _darkMode;

  // Singleton pattern
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  // Getter for dynamic mode
  bool get dynamicMode => _dynamicMode;

  // Getter for dark mode
  bool? get darkMode => _darkMode;

  // Initialize Hive and load settings
  Future<void> init() async {
    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Open box
      _settingsBox = await Hive.openBox(_boxName);

      // Load existing setting
      _loadDynamicMode();
      _loadDarkMode();

      debugPrint('SettingsService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing SettingsService: $e');
      _dynamicMode = false;
    }
  }

  // Load dynamic mode setting from Hive
  void _loadDynamicMode() {
    try {
      _dynamicMode =
          _settingsBox?.get(_dynamicModeKey, defaultValue: false) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading dynamic mode setting: $e');
      _dynamicMode = false;
    }
  }

  // Set dynamic mode setting
  Future<void> setDynamicMode(bool value) async {
    try {
      _dynamicMode = value;
      await _settingsBox?.put(_dynamicModeKey, value);
      notifyListeners();
      debugPrint('Dynamic mode set to: $value');
    } catch (e) {
      debugPrint('Error saving dynamic mode setting: $e');
    }
  }

  // Toggle dynamic mode
  Future<void> toggleDynamicMode() async {
    await setDynamicMode(!_dynamicMode);
  }

  void _loadDarkMode() {
    try {
      _darkMode = _settingsBox?.get(_darkModeKey, defaultValue: null);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading dark mode setting: $e');
      _darkMode = null;
    }
  }

  Future<void> setDarkMode(bool? value) async {
    try {
      _darkMode = value;
      await _settingsBox?.put(_darkModeKey, value);
      notifyListeners();
      debugPrint('Dark mode set to: $value');
    } catch (e) {
      debugPrint('Error saving dark mode setting: $e');
    }
  }

  // Close Hive box
  Future<void> dispose() async {
    await _settingsBox?.close();
    super.dispose();
  }
}
