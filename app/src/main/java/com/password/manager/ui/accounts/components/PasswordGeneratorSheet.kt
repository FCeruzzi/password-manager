package com.password.manager.ui.accounts.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Button
import androidx.compose.material3.Checkbox
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Slider
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import com.password.manager.ui.common.copyToClipboard
import com.password.manager.utils.PasswordGenerator
import com.password.manager.utils.PasswordOptions
import kotlin.math.roundToInt

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PasswordGeneratorSheet(
    onDismiss: () -> Unit,
    onPasswordSelected: (String) -> Unit
) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    val context = LocalContext.current

    var length by remember { mutableFloatStateOf(16f) }
    var useUppercase by remember { mutableStateOf(true) }
    var useLowercase by remember { mutableStateOf(true) }
    var useDigits by remember { mutableStateOf(true) }
    var useSymbols by remember { mutableStateOf(true) }

    var generatedPassword by remember {
        mutableStateOf(PasswordGenerator.generate())
    }

    fun regenerate() {
        generatedPassword = PasswordGenerator.generate(
            PasswordOptions(
                length = length.roundToInt(),
                useUppercase = useUppercase,
                useLowercase = useLowercase,
                useDigits = useDigits,
                useSymbols = useSymbols
            )
        )
    }

    ModalBottomSheet(
        onDismissRequest = onDismiss,
        sheetState = sheetState
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp)
                .padding(bottom = 32.dp)
        ) {
            Text(
                text = "Genera password",
                style = MaterialTheme.typography.titleLarge
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Generated password display
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = generatedPassword,
                    style = MaterialTheme.typography.bodyLarge.copy(fontFamily = FontFamily.Monospace),
                    modifier = Modifier.weight(1f),
                    color = MaterialTheme.colorScheme.primary
                )
                IconButton(onClick = { context.copyToClipboard("Password", generatedPassword) }) {
                    Icon(Icons.Default.ContentCopy, contentDescription = "Copia")
                }
                IconButton(onClick = { regenerate() }) {
                    Icon(Icons.Default.Refresh, contentDescription = "Rigenera")
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Length slider
            Text(
                text = "Lunghezza: ${length.roundToInt()}",
                style = MaterialTheme.typography.labelLarge
            )
            Slider(
                value = length,
                onValueChange = { length = it; regenerate() },
                valueRange = 8f..64f,
                steps = 55
            )

            Spacer(modifier = Modifier.height(8.dp))

            // Character options
            OptionRow("Maiuscole (A-Z)", useUppercase) { useUppercase = it; regenerate() }
            OptionRow("Minuscole (a-z)", useLowercase) { useLowercase = it; regenerate() }
            OptionRow("Numeri (0-9)", useDigits) { useDigits = it; regenerate() }
            OptionRow("Simboli (!@#...)", useSymbols) { useSymbols = it; regenerate() }

            Spacer(modifier = Modifier.height(16.dp))

            Button(
                onClick = { onPasswordSelected(generatedPassword) },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Usa questa password")
            }
        }
    }
}

@Composable
private fun OptionRow(
    label: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(text = label, style = MaterialTheme.typography.bodyMedium)
        Checkbox(checked = checked, onCheckedChange = onCheckedChange)
    }
}
