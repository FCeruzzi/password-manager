import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Settings keys
const _kThemeMode = 'theme_mode';
const _kAutoLockTimeout = 'auto_lock_timeout';
const _kClipboardClearDelay = 'clipboard_clear_delay';
const _kBiometricEnabled = 'biometric_enabled';
const _kRecentFiles = 'recent_files';
const _kOnboardingComplete = 'onboarding_complete';
const _kStayAwake = 'stay_awake';
const _kAllowScreenshots = 'allow_screenshots';
const _kAutoExit = 'auto_exit';
const _kLocale = 'locale';

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

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs?.setString(_kThemeMode, mode.name);
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

  Future<void> setTimeout(Duration timeout) async {
    state = timeout;
    await _prefs?.setInt(_kAutoLockTimeout, timeout.inSeconds);
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

  Future<void> setDelay(Duration delay) async {
    state = delay;
    await _prefs?.setInt(_kClipboardClearDelay, delay.inSeconds);
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

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _prefs?.setBool(_kBiometricEnabled, enabled);
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

  Future<void> addFile(String filePath) async {
    final files = [...state];
    files.remove(filePath);
    files.insert(0, filePath);
    if (files.length > 10) files.removeLast();
    state = files;
    await _prefs?.setStringList(_kRecentFiles, files);
  }

  Future<void> removeFile(String filePath) async {
    final files = [...state];
    files.remove(filePath);
    state = files;
    await _prefs?.setStringList(_kRecentFiles, files);
  }
}

final onboardingCompleteProvider = StateNotifierProvider<OnboardingCompleteNotifier, bool>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return OnboardingCompleteNotifier(prefs);
  } catch (_) {
    return OnboardingCompleteNotifier(null);
  }
});

class OnboardingCompleteNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;

  OnboardingCompleteNotifier(this._prefs) : super(_prefs?.getBool(_kOnboardingComplete) ?? false);

  Future<void> setComplete() async {
    state = true;
    await _prefs?.setBool(_kOnboardingComplete, true);
  }
}

// Stay Awake
final stayAwakeProvider = StateNotifierProvider<StayAwakeNotifier, bool>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return StayAwakeNotifier(prefs);
  } catch (_) {
    return StayAwakeNotifier(null);
  }
});

class StayAwakeNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;

  StayAwakeNotifier(this._prefs) : super(_prefs?.getBool(_kStayAwake) ?? false);

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _prefs?.setBool(_kStayAwake, enabled);
  }
}

// Allow Screenshots
final allowScreenshotsProvider = StateNotifierProvider<AllowScreenshotsNotifier, bool>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AllowScreenshotsNotifier(prefs);
  } catch (_) {
    return AllowScreenshotsNotifier(null);
  }
});

class AllowScreenshotsNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;

  AllowScreenshotsNotifier(this._prefs) : super(_prefs?.getBool(_kAllowScreenshots) ?? false);

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _prefs?.setBool(_kAllowScreenshots, enabled);
  }
}

// Auto Exit
final autoExitProvider = StateNotifierProvider<AutoExitNotifier, bool>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AutoExitNotifier(prefs);
  } catch (_) {
    return AutoExitNotifier(null);
  }
});

class AutoExitNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;

  AutoExitNotifier(this._prefs) : super(_prefs?.getBool(_kAutoExit) ?? false);

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _prefs?.setBool(_kAutoExit, enabled);
  }
}

// Locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return LocaleNotifier(prefs);
  } catch (_) {
    return LocaleNotifier(null);
  }
});

class LocaleNotifier extends StateNotifier<Locale?> {
  final SharedPreferences? _prefs;

  LocaleNotifier(this._prefs) : super(_loadLocale(_prefs));

  static Locale? _loadLocale(SharedPreferences? prefs) {
    final code = prefs?.getString(_kLocale);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await _prefs?.remove(_kLocale);
    } else {
      await _prefs?.setString(_kLocale, locale.languageCode);
    }
  }
}
