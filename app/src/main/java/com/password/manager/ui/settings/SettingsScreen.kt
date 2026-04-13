package com.password.manager.ui.settings

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FileDownload
import androidx.compose.material.icons.filled.FileUpload
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.ContentPaste
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Snackbar
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.password.manager.ui.settings.components.PasswordDialog

private data class TimeoutOption(val label: String, val valueMs: Long)

private val autoLockOptions = listOf(
    TimeoutOption("Immediato", 0L),
    TimeoutOption("30 secondi", 30_000L),
    TimeoutOption("1 minuto", 60_000L),
    TimeoutOption("5 minuti", 300_000L),
    TimeoutOption("Mai", -1L)
)

private val clipboardClearOptions = listOf(
    TimeoutOption("Disattivato", 0L),
    TimeoutOption("15 secondi", 15_000L),
    TimeoutOption("30 secondi", 30_000L),
    TimeoutOption("1 minuto", 60_000L),
    TimeoutOption("2 minuti", 120_000L)
)

@Composable
fun SettingsScreen(viewModel: SettingsViewModel) {
    val state by viewModel.uiState.collectAsState()

    // SAF launchers
    var exportPassword by remember { mutableStateOf("") }
    var pendingImportUri by remember { mutableStateOf<Uri?>(null) }

    val exportLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.CreateDocument("application/octet-stream")
    ) { uri ->
        if (uri != null && exportPassword.isNotBlank()) {
            viewModel.exportData(uri, exportPassword)
            exportPassword = ""
        }
    }

    val importLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.OpenDocument()
    ) { uri ->
        if (uri != null) {
            pendingImportUri = uri
            viewModel.showImportDialog()
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text(
            text = "Impostazioni",
            style = MaterialTheme.typography.headlineSmall
        )

        Spacer(modifier = Modifier.height(24.dp))

        // ── Sicurezza ──
        Text(
            text = "Sicurezza",
            style = MaterialTheme.typography.titleSmall,
            color = MaterialTheme.colorScheme.primary,
            modifier = Modifier.padding(bottom = 8.dp)
        )

        // Biometric toggle
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = "Sblocco biometrico",
                    style = MaterialTheme.typography.titleMedium
                )
                Text(
                    text = if (state.biometricAvailable)
                        "Usa l'impronta digitale per accedere"
                    else
                        "Biometria non disponibile su questo dispositivo",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            Switch(
                checked = state.biometricEnabled,
                onCheckedChange = { viewModel.toggleBiometric(it) },
                enabled = state.biometricAvailable
            )
        }

        Spacer(modifier = Modifier.height(8.dp))

        // Auto-lock timeout
        TimeoutSelector(
            icon = Icons.Default.Lock,
            title = "Blocco automatico",
            subtitle = "Blocca l'app dopo il tempo selezionato",
            options = autoLockOptions,
            currentValue = state.autoLockTimeoutMs,
            onSelected = { viewModel.setAutoLockTimeout(it) }
        )

        Spacer(modifier = Modifier.height(8.dp))

        // Clipboard auto-clear
        TimeoutSelector(
            icon = Icons.Default.ContentPaste,
            title = "Pulizia appunti",
            subtitle = "Cancella gli appunti dopo la copia",
            options = clipboardClearOptions,
            currentValue = state.clipboardClearDelayMs,
            onSelected = { viewModel.setClipboardClearDelay(it) }
        )

        HorizontalDivider(modifier = Modifier.padding(vertical = 16.dp))

        // ── Dati ──
        Text(
            text = "Dati",
            style = MaterialTheme.typography.titleSmall,
            color = MaterialTheme.colorScheme.primary,
            modifier = Modifier.padding(bottom = 8.dp)
        )

        // Export
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clickable { viewModel.showExportDialog() }
                .padding(vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                Icons.Default.FileUpload,
                contentDescription = null,
                modifier = Modifier.padding(end = 16.dp),
                tint = MaterialTheme.colorScheme.primary
            )
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = "Esporta dati",
                    style = MaterialTheme.typography.titleMedium
                )
                Text(
                    text = "Salva tutti i dati in un file cifrato",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }

        // Import
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clickable { importLauncher.launch(arrayOf("*/*")) }
                .padding(vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                Icons.Default.FileDownload,
                contentDescription = null,
                modifier = Modifier.padding(end = 16.dp),
                tint = MaterialTheme.colorScheme.primary
            )
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = "Importa dati",
                    style = MaterialTheme.typography.titleMedium
                )
                Text(
                    text = "Ripristina dati da un file cifrato",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }

        HorizontalDivider(modifier = Modifier.padding(vertical = 16.dp))

        if (state.isProcessing) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                CircularProgressIndicator(modifier = Modifier.padding(end = 12.dp))
                Text("Operazione in corso...")
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        state.message?.let { msg ->
            Snackbar(
                action = {
                    TextButton(onClick = { viewModel.dismissMessage() }) {
                        Text("OK")
                    }
                }
            ) {
                Text(msg)
            }
            Spacer(modifier = Modifier.height(8.dp))
        }

        Text(
            text = "Password Manager v1.0",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }

    // Export password dialog
    if (state.showExportDialog) {
        PasswordDialog(
            title = "Esporta dati",
            confirmLabel = "Esporta",
            onConfirm = { password ->
                exportPassword = password
                viewModel.dismissDialogs()
                exportLauncher.launch("password_manager_backup.pwm")
            },
            onDismiss = { viewModel.dismissDialogs() }
        )
    }

    // Import password dialog
    if (state.showImportDialog) {
        PasswordDialog(
            title = "Importa dati",
            confirmLabel = "Importa",
            onConfirm = { password ->
                pendingImportUri?.let { uri ->
                    viewModel.importData(uri, password)
                }
                pendingImportUri = null
            },
            onDismiss = {
                viewModel.dismissDialogs()
                pendingImportUri = null
            }
        )
    }
}

@Composable
private fun TimeoutSelector(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    title: String,
    subtitle: String,
    options: List<TimeoutOption>,
    currentValue: Long,
    onSelected: (Long) -> Unit
) {
    var expanded by remember { mutableStateOf(false) }
    val currentLabel = options.find { it.valueMs == currentValue }?.label ?: "Personalizzato"

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { expanded = true }
            .padding(vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            icon,
            contentDescription = null,
            modifier = Modifier.padding(end = 16.dp),
            tint = MaterialTheme.colorScheme.primary
        )
        Column(modifier = Modifier.weight(1f)) {
            Text(title, style = MaterialTheme.typography.titleMedium)
            Text(
                subtitle,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
        Text(
            currentLabel,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.primary
        )
        DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
            options.forEach { option ->
                DropdownMenuItem(
                    text = { Text(option.label) },
                    onClick = {
                        onSelected(option.valueMs)
                        expanded = false
                    }
                )
            }
        }
    }
}
