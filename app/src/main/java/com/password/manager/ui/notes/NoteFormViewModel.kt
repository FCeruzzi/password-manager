package com.password.manager.ui.notes

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.viewModelScope
import com.password.manager.PasswordManagerApp
import com.password.manager.data.entity.SecureNoteEntity
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class NoteFormState(
    val title: String = "",
    val content: String = "",
    val isEditing: Boolean = false,
    val isSaved: Boolean = false,
    val error: String? = null
)

class NoteFormViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application) {

    private val repository = (application as PasswordManagerApp).secureNoteRepository
    private val noteId: Long = savedStateHandle.get<Long>("noteId") ?: 0L

    private val _formState = MutableStateFlow(NoteFormState())
    val formState: StateFlow<NoteFormState> = _formState.asStateFlow()

    init {
        if (noteId > 0L) {
            viewModelScope.launch {
                repository.getById(noteId).collect { entity ->
                    if (entity != null) {
                        _formState.value = NoteFormState(
                            title = entity.title,
                            content = entity.content,
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

    fun onContentChanged(value: String) {
        _formState.value = _formState.value.copy(content = value, error = null)
    }

    fun save() {
        val state = _formState.value
        if (state.title.isBlank()) {
            _formState.value = state.copy(error = "Il titolo è obbligatorio")
            return
        }
        viewModelScope.launch {
            if (state.isEditing) {
                repository.update(
                    SecureNoteEntity(
                        id = noteId,
                        title = state.title.trim(),
                        content = state.content.trim(),
                        updatedAt = System.currentTimeMillis()
                    )
                )
            } else {
                repository.insert(
                    SecureNoteEntity(
                        title = state.title.trim(),
                        content = state.content.trim()
                    )
                )
            }
            _formState.value = _formState.value.copy(isSaved = true)
        }
    }
}
