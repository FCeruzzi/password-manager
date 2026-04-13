package com.password.manager.ui.settings

import android.app.Application
import android.net.Uri
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.password.manager.PasswordManagerApp
import com.password.manager.ui.auth.BiometricHelper
import com.password.manager.utils.ExportImportManager
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class SettingsUiState(
    val biometricEnabled: Boolean = false,
    val biometricAvailable: Boolean = false,
    val autoLockTimeoutMs: Long = 60_000L,
    val clipboardClearDelayMs: Long = 30_000L,
    val showExportDialog: Boolean = false,
    val showImportDialog: Boolean = false,
    val isProcessing: Boolean = false,
    val message: String? = null
)

class SettingsViewModel(application: Application) : AndroidViewModel(application) {

    private val app = application as PasswordManagerApp
    private val securePrefs = app.securePrefs

    val exportImportManager = ExportImportManager(
        app.accountRepository,
        app.creditCardRepository,
        app.secureNoteRepository
    )

    private val _uiState = MutableStateFlow(
        SettingsUiState(
            biometricEnabled = securePrefs.isBiometricEnabled(),
            biometricAvailable = BiometricHelper.canAuthenticate(application),
            autoLockTimeoutMs = securePrefs.getAutoLockTimeoutMs(),
            clipboardClearDelayMs = securePrefs.getClipboardClearDelayMs()
        )
    )
    val uiState: StateFlow<SettingsUiState> = _uiState.asStateFlow()

    fun toggleBiometric(enabled: Boolean) {
        securePrefs.setBiometricEnabled(enabled)
        _uiState.value = _uiState.value.copy(biometricEnabled = enabled)
    }

    fun setAutoLockTimeout(timeoutMs: Long) {
        securePrefs.setAutoLockTimeoutMs(timeoutMs)
        _uiState.value = _uiState.value.copy(autoLockTimeoutMs = timeoutMs)
    }

    fun setClipboardClearDelay(delayMs: Long) {
        securePrefs.setClipboardClearDelayMs(delayMs)
        _uiState.value = _uiState.value.copy(clipboardClearDelayMs = delayMs)
    }

    fun showExportDialog() {
        _uiState.value = _uiState.value.copy(showExportDialog = true)
    }

    fun showImportDialog() {
        _uiState.value = _uiState.value.copy(showImportDialog = true)
    }

    fun dismissDialogs() {
        _uiState.value = _uiState.value.copy(
            showExportDialog = false,
            showImportDialog = false
        )
    }

    fun dismissMessage() {
        _uiState.value = _uiState.value.copy(message = null)
    }

    fun exportData(uri: Uri, password: String) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isProcessing = true,
                showExportDialog = false
            )
            try {
                exportImportManager.exportToUri(getApplication(), uri, password)
                _uiState.value = _uiState.value.copy(
                    isProcessing = false,
                    message = "Dati esportati con successo"
                )
            } catch (_: Exception) {
                _uiState.value = _uiState.value.copy(
                    isProcessing = false,
                    message = "Errore durante l'esportazione"
                )
            }
        }
    }

    fun importData(uri: Uri, password: String) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isProcessing = true,
                showImportDialog = false
            )
            val result = exportImportManager.importFromUri(getApplication(), uri, password)
            _uiState.value = _uiState.value.copy(
                isProcessing = false,
                message = result.summary
            )
        }
    }
}
