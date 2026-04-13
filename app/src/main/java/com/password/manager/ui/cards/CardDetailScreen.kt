package com.password.manager.ui.cards

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.password.manager.data.entity.CreditCardEntity
import com.password.manager.ui.common.copyToClipboard
import com.password.manager.ui.common.maskCardNumber
import com.password.manager.ui.common.toFormattedDate
import kotlinx.coroutines.flow.Flow

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CardDetailScreen(
    cardFlow: Flow<CreditCardEntity?>,
    onBack: () -> Unit,
    onEdit: (Long) -> Unit
) {
    val card by cardFlow.collectAsState(initial = null)
    val context = LocalContext.current
    var numberVisible by remember { mutableStateOf(false) }
    var cvvVisible by remember { mutableStateOf(false) }
    var pinVisible by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(card?.holderName ?: "") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Indietro")
                    }
                },
                actions = {
                    card?.let { c ->
                        IconButton(onClick = { onEdit(c.id) }) {
                            Icon(Icons.Default.Edit, contentDescription = "Modifica")
                        }
                    }
                }
            )
        }
    ) { padding ->
        card?.let { c ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .padding(16.dp)
                    .verticalScroll(rememberScrollState())
            ) {
                // Card Number
                SensitiveDetailRow(
                    label = "Numero carta",
                    value = c.cardNumber,
                    maskedValue = c.cardNumber.maskCardNumber(),
                    isVisible = numberVisible,
                    onToggleVisibility = { numberVisible = !numberVisible },
                    onCopy = { context.copyToClipboard("Numero carta", c.cardNumber) }
                )

                Spacer(modifier = Modifier.height(16.dp))

                DetailRow(label = "Scadenza", value = c.expiryDate) {
                    context.copyToClipboard("Scadenza", c.expiryDate)
                }

                Spacer(modifier = Modifier.height(16.dp))

                // CVV
                SensitiveDetailRow(
                    label = "CVV",
                    value = c.cvv,
                    maskedValue = "•••",
                    isVisible = cvvVisible,
                    onToggleVisibility = { cvvVisible = !cvvVisible },
                    onCopy = { context.copyToClipboard("CVV", c.cvv) }
                )

                if (c.pin.isNotBlank()) {
                    Spacer(modifier = Modifier.height(16.dp))
                    SensitiveDetailRow(
                        label = "PIN",
                        value = c.pin,
                        maskedValue = "••••",
                        isVisible = pinVisible,
                        onToggleVisibility = { pinVisible = !pinVisible },
                        onCopy = { context.copyToClipboard("PIN", c.pin) }
                    )
                }

                if (c.circuit.isNotBlank()) {
                    Spacer(modifier = Modifier.height(16.dp))
                    DetailRow(label = "Circuito", value = c.circuit) {
                        context.copyToClipboard("Circuito", c.circuit)
                    }
                }

                Spacer(modifier = Modifier.height(24.dp))
                Text(
                    text = "Creato: ${c.createdAt.toFormattedDate()}",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Text(
                    text = "Modificato: ${c.updatedAt.toFormattedDate()}",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
private fun DetailRow(label: String, value: String, onCopy: () -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = label,
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Text(text = value, style = MaterialTheme.typography.bodyLarge)
        }
        IconButton(onClick = onCopy) {
            Icon(Icons.Default.ContentCopy, contentDescription = "Copia $label")
        }
    }
}

@Composable
private fun SensitiveDetailRow(
    label: String,
    value: String,
    maskedValue: String,
    isVisible: Boolean,
    onToggleVisibility: () -> Unit,
    onCopy: () -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = label,
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Text(
                text = if (isVisible) value else maskedValue,
                style = MaterialTheme.typography.bodyLarge
            )
        }
        IconButton(onClick = onToggleVisibility) {
            Icon(
                if (isVisible) Icons.Default.VisibilityOff else Icons.Default.Visibility,
                contentDescription = "Mostra/nascondi"
            )
        }
        IconButton(onClick = onCopy) {
            Icon(Icons.Default.ContentCopy, contentDescription = "Copia $label")
        }
    }
}
