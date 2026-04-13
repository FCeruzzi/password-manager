package com.password.manager

import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.ProcessLifecycleOwner
import com.password.manager.ui.navigation.AppNavGraph
import com.password.manager.ui.theme.PasswordManagerTheme
import com.password.manager.utils.AutoLockManager

class MainActivity : FragmentActivity() {

    private var autoLockManager: AutoLockManager? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val app = applicationContext as PasswordManagerApp
        autoLockManager = AutoLockManager(app.securePrefs) {
            // Navigate to auth on lock — handled via shared flag
            app.lockRequested = true
        }
        ProcessLifecycleOwner.get().lifecycle.addObserver(autoLockManager!!)

        setContent {
            PasswordManagerTheme {
                Surface(modifier = Modifier.fillMaxSize()) {
                    AppNavGraph()
                }
            }
        }
    }

    override fun onDestroy() {
        autoLockManager?.let {
            ProcessLifecycleOwner.get().lifecycle.removeObserver(it)
        }
        super.onDestroy()
    }
}
