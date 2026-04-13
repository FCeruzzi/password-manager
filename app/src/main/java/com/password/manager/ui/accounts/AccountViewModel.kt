package com.password.manager.ui.accounts

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.password.manager.PasswordManagerApp
import com.password.manager.data.entity.AccountEntity
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

@OptIn(ExperimentalCoroutinesApi::class)
class AccountViewModel(application: Application) : AndroidViewModel(application) {

    private val repository = (application as PasswordManagerApp).accountRepository

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery.asStateFlow()

    val accounts: StateFlow<List<AccountEntity>> = _searchQuery
        .flatMapLatest { query ->
            if (query.isBlank()) repository.getAll()
            else repository.search("%$query%")
        }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    fun onSearchQueryChanged(query: String) {
        _searchQuery.value = query
    }

    fun delete(account: AccountEntity) {
        viewModelScope.launch { repository.delete(account) }
    }
}
