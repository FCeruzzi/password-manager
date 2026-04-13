import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Settings keys
const _kThemeMode = 'theme_mode';
const _kAutoLockTimeout = 'auto_lock_timeout';
const _kClipboardClearDelay = 'clipboard_clear_delay';
const _kBiometricEnabled = 'biometric_enabled';
const _kRecentFiles = 'recent_files';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in main');
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return ThemeModeNotifier(prefs);
  } catch (_) {
    return ThemeModeNotifier(null);
  }
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences? _prefs;

  ThemeModeNotifier(this._prefs) : super(_loadThemeMode(_prefs));

  static ThemeMode _loadThemeMode(SharedPreferences? prefs) {
    final value = prefs?.getString(_kThemeMode);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    _prefs?.setString(_kThemeMode, mode.name);
  }
}

final autoLockTimeoutProvider = StateNotifierProvider<AutoLockTimeoutNotifier, Duration>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AutoLockTimeoutNotifier(prefs);
  } catch (_) {
    return AutoLockTimeoutNotifier(null);
  }
});

class AutoLockTimeoutNotifier extends StateNotifier<Duration> {
  final SharedPreferences? _prefs;

  AutoLockTimeoutNotifier(this._prefs) : super(_load(_prefs));

  static Duration _load(SharedPreferences? prefs) {
    final seconds = prefs?.getInt(_kAutoLockTimeout) ?? 60;
    return Duration(seconds: seconds);
  }

  void setTimeout(Duration timeout) {
    state = timeout;
    _prefs?.setInt(_kAutoLockTimeout, timeout.inSeconds);
  }
}

final clipboardClearDelayProvider = StateNotifierProvider<ClipboardClearDelayNotifier, Duration>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return ClipboardClearDelayNotifier(prefs);
  } catch (_) {
    return ClipboardClearDelayNotifier(null);
  }
});

class ClipboardClearDelayNotifier extends StateNotifier<Duration> {
  final SharedPreferences? _prefs;

  ClipboardClearDelayNotifier(this._prefs) : super(_load(_prefs));

  static Duration _load(SharedPreferences? prefs) {
    final seconds = prefs?.getInt(_kClipboardClearDelay) ?? 30;
    return Duration(seconds: seconds);
  }

  void setDelay(Duration delay) {
    state = delay;
    _prefs?.setInt(_kClipboardClearDelay, delay.inSeconds);
  }
}

final biometricEnabledProvider = StateNotifierProvider<BiometricEnabledNotifier, bool>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return BiometricEnabledNotifier(prefs);
  } catch (_) {
    return BiometricEnabledNotifier(null);
  }
});

class BiometricEnabledNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;

  BiometricEnabledNotifier(this._prefs) : super(_prefs?.getBool(_kBiometricEnabled) ?? false);

  void setEnabled(bool enabled) {
    state = enabled;
    _prefs?.setBool(_kBiometricEnabled, enabled);
  }
}

final recentFilesProvider = StateNotifierProvider<RecentFilesNotifier, List<String>>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return RecentFilesNotifier(prefs);
  } catch (_) {
    return RecentFilesNotifier(null);
  }
});

class RecentFilesNotifier extends StateNotifier<List<String>> {
  final SharedPreferences? _prefs;

  RecentFilesNotifier(this._prefs) : super(_prefs?.getStringList(_kRecentFiles) ?? []);

  void addFile(String filePath) {
    final files = [...state];
    files.remove(filePath);
    files.insert(0, filePath);
    if (files.length > 10) files.removeLast();
    state = files;
    _prefs?.setStringList(_kRecentFiles, files);
  }

  void removeFile(String filePath) {
    final files = [...state];
    files.remove(filePath);
    state = files;
    _prefs?.setStringList(_kRecentFiles, files);
  }
}
