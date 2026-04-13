package com.password.manager.data.security

import android.content.Context
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import java.security.SecureRandom
import android.util.Base64

class SecurePreferencesManager(context: Context) {

    private val masterKey = MasterKey.Builder(context)
        .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
        .build()

    private val prefs: SharedPreferences = EncryptedSharedPreferences.create(
        context,
        PREFS_FILE_NAME,
        masterKey,
        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
    )

    fun saveMasterPinHash(pinHash: String) {
        prefs.edit().putString(KEY_MASTER_PIN_HASH, pinHash).apply()
    }

    fun getMasterPinHash(): String? {
        return prefs.getString(KEY_MASTER_PIN_HASH, null)
    }

    fun isMasterPinSet(): Boolean {
        return prefs.contains(KEY_MASTER_PIN_HASH)
    }

    fun isBiometricEnabled(): Boolean {
        return prefs.getBoolean(KEY_BIOMETRIC_ENABLED, false)
    }

    fun setBiometricEnabled(enabled: Boolean) {
        prefs.edit().putBoolean(KEY_BIOMETRIC_ENABLED, enabled).apply()
    }

    fun getDatabasePassphrase(): ByteArray {
        val existing = prefs.getString(KEY_DB_PASSPHRASE, null)
        if (existing != null) {
            return Base64.decode(existing, Base64.NO_WRAP)
        }
        val passphrase = generatePassphrase()
        prefs.edit()
            .putString(KEY_DB_PASSPHRASE, Base64.encodeToString(passphrase, Base64.NO_WRAP))
            .apply()
        return passphrase
    }

    // Auto-lock timeout in milliseconds (0 = immediate, -1 = never)
    fun getAutoLockTimeoutMs(): Long {
        return prefs.getLong(KEY_AUTO_LOCK_TIMEOUT, 60_000L) // default 1 min
    }

    fun setAutoLockTimeoutMs(timeoutMs: Long) {
        prefs.edit().putLong(KEY_AUTO_LOCK_TIMEOUT, timeoutMs).apply()
    }

    // Clipboard auto-clear delay in milliseconds (0 = disabled)
    fun getClipboardClearDelayMs(): Long {
        return prefs.getLong(KEY_CLIPBOARD_CLEAR_DELAY, 30_000L) // default 30s
    }

    fun setClipboardClearDelayMs(delayMs: Long) {
        prefs.edit().putLong(KEY_CLIPBOARD_CLEAR_DELAY, delayMs).apply()
    }

    fun clearAll() {
        prefs.edit().clear().apply()
    }

    private fun generatePassphrase(): ByteArray {
        val random = SecureRandom()
        val passphrase = ByteArray(32)
        random.nextBytes(passphrase)
        return passphrase
    }

    companion object {
        private const val PREFS_FILE_NAME = "password_manager_secure_prefs"
        private const val KEY_MASTER_PIN_HASH = "master_pin_hash"
        private const val KEY_BIOMETRIC_ENABLED = "biometric_enabled"
        private const val KEY_DB_PASSPHRASE = "db_passphrase"
        private const val KEY_AUTO_LOCK_TIMEOUT = "auto_lock_timeout"
        private const val KEY_CLIPBOARD_CLEAR_DELAY = "clipboard_clear_delay"
    }
}
