package com.password.manager.ui.auth

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.password.manager.PasswordManagerApp
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.security.MessageDigest

data class AuthUiState(
    val isFirstLaunch: Boolean = true,
    val isAuthenticated: Boolean = false,
    val pin: String = "",
    val confirmPin: String = "",
    val isConfirmStep: Boolean = false,
    val error: String? = null,
    val biometricEnabled: Boolean = false,
    val showBiometricPrompt: Boolean = false
)

class AuthViewModel(application: Application) : AndroidViewModel(application) {

    private val securePrefs = (application as PasswordManagerApp).securePrefs

    private val _uiState = MutableStateFlow(AuthUiState())
    val uiState: StateFlow<AuthUiState> = _uiState.asStateFlow()

    init {
        val isPinSet = securePrefs.isMasterPinSet()
        val biometricEnabled = securePrefs.isBiometricEnabled()
        _uiState.value = AuthUiState(
            isFirstLaunch = !isPinSet,
            biometricEnabled = biometricEnabled,
            showBiometricPrompt = isPinSet && biometricEnabled
        )
    }

    fun onPinDigitEntered(digit: Char) {
        val current = _uiState.value
        if (current.isFirstLaunch) {
            if (!current.isConfirmStep) {
                if (current.pin.length < PIN_LENGTH) {
                    val newPin = current.pin + digit
                    _uiState.value = current.copy(pin = newPin, error = null)
                    if (newPin.length == PIN_LENGTH) {
                        _uiState.value = _uiState.value.copy(isConfirmStep = true)
                    }
                }
            } else {
                if (current.confirmPin.length < PIN_LENGTH) {
                    val newConfirm = current.confirmPin + digit
                    _uiState.value = current.copy(confirmPin = newConfirm, error = null)
                    if (newConfirm.length == PIN_LENGTH) {
                        setupPin()
                    }
                }
            }
        } else {
            if (current.pin.length < PIN_LENGTH) {
                val newPin = current.pin + digit
                _uiState.value = current.copy(pin = newPin, error = null)
                if (newPin.length == PIN_LENGTH) {
                    verifyPin()
                }
            }
        }
    }

    fun onPinDigitRemoved() {
        val current = _uiState.value
        if (current.isFirstLaunch && current.isConfirmStep) {
            if (current.confirmPin.isNotEmpty()) {
                _uiState.value = current.copy(
                    confirmPin = current.confirmPin.dropLast(1),
                    error = null
                )
            }
        } else {
            if (current.pin.isNotEmpty()) {
                _uiState.value = current.copy(
                    pin = current.pin.dropLast(1),
                    error = null
                )
            }
        }
    }

    private fun setupPin() {
        val current = _uiState.value
        if (current.pin != current.confirmPin) {
            _uiState.value = current.copy(
                confirmPin = "",
                error = "I PIN non corrispondono. Riprova."
            )
            return
        }
        viewModelScope.launch {
            val hash = hashPin(current.pin)
            securePrefs.saveMasterPinHash(hash)
            _uiState.value = current.copy(isAuthenticated = true)
        }
    }

    private fun verifyPin() {
        val current = _uiState.value
        val hash = hashPin(current.pin)
        val stored = securePrefs.getMasterPinHash()
        if (hash == stored) {
            _uiState.value = current.copy(isAuthenticated = true)
        } else {
            _uiState.value = current.copy(
                pin = "",
                error = "PIN errato. Riprova."
            )
        }
    }

    fun onBiometricSuccess() {
        _uiState.value = _uiState.value.copy(isAuthenticated = true)
    }

    fun onBiometricFailed() {
        _uiState.value = _uiState.value.copy(
            showBiometricPrompt = false,
            error = "Autenticazione biometrica fallita."
        )
    }

    fun requestBiometricPrompt() {
        _uiState.value = _uiState.value.copy(showBiometricPrompt = true)
    }

    fun dismissError() {
        _uiState.value = _uiState.value.copy(error = null)
    }

    private fun hashPin(pin: String): String {
        val digest = MessageDigest.getInstance("SHA-256")
        val bytes = digest.digest(pin.toByteArray(Charsets.UTF_8))
        return bytes.joinToString("") { "%02x".format(it) }
    }

    companion object {
        const val PIN_LENGTH = 6
    }
}
