import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _kMasterPasswordKey = 'quick_unlock_master_password';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isLocked = true;

  bool get isLocked => _isLocked;

  void lock() => _isLocked = true;
  void unlock() => _isLocked = false;

  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometric({
    required String localizedReason,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }

  Future<void> storeMasterPasswordForQuickUnlock(String password) async {
    await _secureStorage.write(key: _kMasterPasswordKey, value: password);
  }

  Future<String?> getStoredMasterPassword() async {
    return _secureStorage.read(key: _kMasterPasswordKey);
  }

  Future<void> clearStoredMasterPassword() async {
    await _secureStorage.delete(key: _kMasterPasswordKey);
  }
}
