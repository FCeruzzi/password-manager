package com.password.manager.ui.accounts

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.viewModelScope
import com.password.manager.PasswordManagerApp
import com.password.manager.data.entity.AccountEntity
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class AccountFormState(
    val title: String = "",
    val username: String = "",
    val password: String = "",
    val url: String = "",
    val notes: String = "",
    val isEditing: Boolean = false,
    val isSaved: Boolean = false,
    val error: String? = null
)

class AccountFormViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application) {

    private val repository = (application as PasswordManagerApp).accountRepository
    private val accountId: Long = savedStateHandle.get<Long>("accountId") ?: 0L

    private val _formState = MutableStateFlow(AccountFormState())
    val formState: StateFlow<AccountFormState> = _formState.asStateFlow()

    init {
        if (accountId > 0L) {
            viewModelScope.launch {
                repository.getById(accountId).collect { entity ->
                    if (entity != null) {
                        _formState.value = AccountFormState(
                            title = entity.title,
                            username = entity.username,
                            password = entity.password,
                            url = entity.url,
                            notes = entity.notes,
                            isEditing = true
                        )
                    }
                }
            }
        }
    }

    fun onTitleChanged(value: String) {
        _formState.value = _formState.value.copy(title = value, error = null)
    }

    fun onUsernameChanged(value: String) {
        _formState.value = _formState.value.copy(username = value, error = null)
    }

    fun onPasswordChanged(value: String) {
        _formState.value = _formState.value.copy(password = value, error = null)
    }

    fun onUrlChanged(value: String) {
        _formState.value = _formState.value.copy(url = value, error = null)
    }

    fun onNotesChanged(value: String) {
        _formState.value = _formState.value.copy(notes = value, error = null)
    }

    fun save() {
        val state = _formState.value
        if (state.title.isBlank()) {
            _formState.value = state.copy(error = "Il titolo è obbligatorio")
            return
        }
        if (state.username.isBlank()) {
            _formState.value = state.copy(error = "L'username è obbligatorio")
            return
        }
        viewModelScope.launch {
            if (state.isEditing) {
                repository.update(
                    AccountEntity(
                        id = accountId,
                        title = state.title.trim(),
                        username = state.username.trim(),
                        password = state.password,
                        url = state.url.trim(),
                        notes = state.notes.trim(),
                        updatedAt = System.currentTimeMillis()
                    )
                )
            } else {
                repository.insert(
                    AccountEntity(
                        title = state.title.trim(),
                        username = state.username.trim(),
                        password = state.password,
                        url = state.url.trim(),
                        notes = state.notes.trim()
                    )
                )
            }
            _formState.value = _formState.value.copy(isSaved = true)
        }
    }
}
