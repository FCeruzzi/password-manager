package com.password.manager.ui.common

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.widget.Toast
import com.password.manager.PasswordManagerApp
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

fun Context.copyToClipboard(label: String, text: String) {
    val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    clipboard.setPrimaryClip(ClipData.newPlainText(label, text))
    Toast.makeText(this, "$label copiato", Toast.LENGTH_SHORT).show()

    val app = applicationContext as? PasswordManagerApp
    val delayMs = app?.securePrefs?.getClipboardClearDelayMs() ?: 30_000L
    if (delayMs > 0) {
        Handler(Looper.getMainLooper()).postDelayed({
            try {
                clipboard.setPrimaryClip(ClipData.newPlainText("", ""))
            } catch (_: Exception) { }
        }, delayMs)
    }
}

fun Long.toFormattedDate(): String {
    val sdf = SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.getDefault())
    return sdf.format(Date(this))
}

fun String.maskCardNumber(): String {
    if (length < 4) return this
    return "**** **** **** ${takeLast(4)}"
}
