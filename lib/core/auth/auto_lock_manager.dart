import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the lock state of the app.
/// When `isLocked` is true, the unlock screen is shown.
final lockStateProvider = StateNotifierProvider<LockStateNotifier, bool>((ref) {
  return LockStateNotifier();
});

class LockStateNotifier extends StateNotifier<bool> {
  LockStateNotifier() : super(true); // Start locked

  DateTime? _lastActivity;

  void lock() => state = true;

  void unlock() {
    state = false;
    _lastActivity = DateTime.now();
  }

  void recordActivity() {
    _lastActivity = DateTime.now();
  }

  /// Checks if we should lock based on inactivity timeout.
  /// Returns true if the app was locked.
  bool checkAutoLock(Duration timeout) {
    if (state) return true; // Already locked
    if (timeout.inSeconds <= 0) return false; // Never auto-lock
    if (_lastActivity == null) {
      lock();
      return true;
    }
    final elapsed = DateTime.now().difference(_lastActivity!);
    if (elapsed >= timeout) {
      lock();
      return true;
    }
    return false;
  }
}
