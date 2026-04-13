package com.password.manager.utils

import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.password.manager.data.security.SecurePreferencesManager

class AutoLockManager(
    private val securePrefs: SecurePreferencesManager,
    private val onLock: () -> Unit
) : DefaultLifecycleObserver {

    private var backgroundTimestamp: Long = 0L

    override fun onStop(owner: LifecycleOwner) {
        backgroundTimestamp = System.currentTimeMillis()
    }

    override fun onStart(owner: LifecycleOwner) {
        if (backgroundTimestamp == 0L) return
        val timeout = securePrefs.getAutoLockTimeoutMs()
        if (timeout < 0) return // -1 = never
        val elapsed = System.currentTimeMillis() - backgroundTimestamp
        if (elapsed >= timeout) {
            onLock()
        }
        backgroundTimestamp = 0L
    }
}
