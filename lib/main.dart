import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/providers/settings_provider.dart';

const _securityChannel = MethodChannel('com.password.password_manager/security');

Future<void> _applyScreenshotPolicy(bool allow) async {
  try {
    await _securityChannel.invokeMethod('setFlagSecure', {'enable': !allow});
  } catch (_) {}
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      SystemNavigator.pop();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final observer = _AppLifecycleObserver();
  WidgetsBinding.instance.addObserver(observer);

  final prefs = await SharedPreferences.getInstance();

  // Apply screenshot policy on startup (default: blocked)
  final allowScreenshots = prefs.getBool('allow_screenshots') ?? false;
  await _applyScreenshotPolicy(allowScreenshots);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PasswordManagerApp(),
    ),
  );
}
