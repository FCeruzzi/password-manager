package com.password.manager.ui.auth

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.fragment.app.FragmentActivity
import com.password.manager.ui.auth.components.PinDots
import com.password.manager.ui.auth.components.PinKeypad

@Composable
fun AuthScreen(
    viewModel: AuthViewModel,
    onAuthenticated: () -> Unit
) {
    val state by viewModel.uiState.collectAsState()
    val context = LocalContext.current

    LaunchedEffect(state.isAuthenticated) {
        if (state.isAuthenticated) {
            onAuthenticated()
        }
    }

    LaunchedEffect(state.showBiometricPrompt) {
        if (state.showBiometricPrompt) {
            val activity = context as? FragmentActivity ?: return@LaunchedEffect
            BiometricHelper.showPrompt(
                activity = activity,
                onSuccess = { viewModel.onBiometricSuccess() },
                onFailed = { viewModel.onBiometricFailed() }
            )
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(
            imageVector = Icons.Default.Lock,
            contentDescription = null,
            modifier = Modifier.size(64.dp),
            tint = MaterialTheme.colorScheme.primary
        )

        Spacer(modifier = Modifier.height(24.dp))

        Text(
            text = if (state.isFirstLaunch) {
                if (state.isConfirmStep) "Conferma PIN" else "Crea un PIN"
            } else {
                "Inserisci il PIN"
            },
            style = MaterialTheme.typography.headlineSmall,
            color = MaterialTheme.colorScheme.onSurface
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = if (state.isFirstLaunch) {
                if (state.isConfirmStep) {
                    "Reinserisci il PIN di 6 cifre"
                } else {
                    "Scegli un PIN di 6 cifre per proteggere i tuoi dati"
                }
            } else {
                "Inserisci il PIN per sbloccare"
            },
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center
        )

        Spacer(modifier = Modifier.height(32.dp))

        PinDots(
            pinLength = AuthViewModel.PIN_LENGTH,
            filledCount = if (state.isFirstLaunch && state.isConfirmStep) {
                state.confirmPin.length
            } else {
                state.pin.length
            }
        )

        Spacer(modifier = Modifier.height(16.dp))

        AnimatedVisibility(
            visible = state.error != null,
            enter = fadeIn(),
            exit = fadeOut()
        ) {
            Text(
                text = state.error.orEmpty(),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.error,
                textAlign = TextAlign.Center
            )
        }

        Spacer(modifier = Modifier.height(32.dp))

        PinKeypad(
            onDigitClick = { viewModel.onPinDigitEntered(it) },
            onBackspaceClick = { viewModel.onPinDigitRemoved() },
            showBiometricButton = !state.isFirstLaunch && state.biometricEnabled,
            onBiometricClick = { viewModel.requestBiometricPrompt() }
        )
    }
}
