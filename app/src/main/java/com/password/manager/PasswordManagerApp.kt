package com.password.manager

import android.app.Application
import com.password.manager.data.db.AppDatabase
import com.password.manager.data.repository.AccountRepositoryImpl
import com.password.manager.data.repository.CreditCardRepositoryImpl
import com.password.manager.data.repository.SecureNoteRepositoryImpl
import com.password.manager.data.security.SecurePreferencesManager
import com.password.manager.domain.repository.AccountRepository
import com.password.manager.domain.repository.CreditCardRepository
import com.password.manager.domain.repository.SecureNoteRepository

class PasswordManagerApp : Application() {

    lateinit var securePrefs: SecurePreferencesManager
        private set

    @Volatile
    var lockRequested: Boolean = false

    val database: AppDatabase by lazy {
        val passphrase = securePrefs.getDatabasePassphrase()
        AppDatabase.getInstance(this, passphrase)
    }

    val accountRepository: AccountRepository by lazy {
        AccountRepositoryImpl(database.accountDao())
    }

    val creditCardRepository: CreditCardRepository by lazy {
        CreditCardRepositoryImpl(database.creditCardDao())
    }

    val secureNoteRepository: SecureNoteRepository by lazy {
        SecureNoteRepositoryImpl(database.secureNoteDao())
    }

    override fun onCreate() {
        super.onCreate()
        System.loadLibrary("sqlcipher")
        securePrefs = SecurePreferencesManager(this)
    }
}
