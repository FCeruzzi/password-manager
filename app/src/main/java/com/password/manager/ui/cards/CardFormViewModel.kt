package com.password.manager.ui.cards

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.viewModelScope
import com.password.manager.PasswordManagerApp
import com.password.manager.data.entity.CreditCardEntity
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class CardFormState(
    val holderName: String = "",
    val cardNumber: String = "",
    val expiryDate: String = "",
    val cvv: String = "",
    val circuit: String = "",
    val pin: String = "",
    val isEditing: Boolean = false,
    val isSaved: Boolean = false,
    val error: String? = null
)

class CardFormViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application) {

    private val repository = (application as PasswordManagerApp).creditCardRepository
    private val cardId: Long = savedStateHandle.get<Long>("cardId") ?: 0L

    private val _formState = MutableStateFlow(CardFormState())
    val formState: StateFlow<CardFormState> = _formState.asStateFlow()

    init {
        if (cardId > 0L) {
            viewModelScope.launch {
                repository.getById(cardId).collect { entity ->
                    if (entity != null) {
                        _formState.value = CardFormState(
                            holderName = entity.holderName,
                            cardNumber = entity.cardNumber,
                            expiryDate = entity.expiryDate,
                            cvv = entity.cvv,
                            circuit = entity.circuit,
                            pin = entity.pin,
                            isEditing = true
                        )
                    }
                }
            }
        }
    }

    fun onHolderNameChanged(value: String) {
        _formState.value = _formState.value.copy(holderName = value, error = null)
    }

    fun onCardNumberChanged(value: String) {
        _formState.value = _formState.value.copy(cardNumber = value, error = null)
    }

    fun onExpiryDateChanged(value: String) {
        _formState.value = _formState.value.copy(expiryDate = value, error = null)
    }

    fun onCvvChanged(value: String) {
        _formState.value = _formState.value.copy(cvv = value, error = null)
    }

    fun onCircuitChanged(value: String) {
        _formState.value = _formState.value.copy(circuit = value, error = null)
    }

    fun onPinChanged(value: String) {
        _formState.value = _formState.value.copy(pin = value, error = null)
    }

    fun save() {
        val state = _formState.value
        if (state.holderName.isBlank()) {
            _formState.value = state.copy(error = "Il nome del titolare è obbligatorio")
            return
        }
        if (state.cardNumber.isBlank()) {
            _formState.value = state.copy(error = "Il numero carta è obbligatorio")
            return
        }
        viewModelScope.launch {
            if (state.isEditing) {
                repository.update(
                    CreditCardEntity(
                        id = cardId,
                        holderName = state.holderName.trim(),
                        cardNumber = state.cardNumber.trim(),
                        expiryDate = state.expiryDate.trim(),
                        cvv = state.cvv.trim(),
                        circuit = state.circuit.trim(),
                        pin = state.pin.trim(),
                        updatedAt = System.currentTimeMillis()
                    )
                )
            } else {
                repository.insert(
                    CreditCardEntity(
                        holderName = state.holderName.trim(),
                        cardNumber = state.cardNumber.trim(),
                        expiryDate = state.expiryDate.trim(),
                        cvv = state.cvv.trim(),
                        circuit = state.circuit.trim(),
                        pin = state.pin.trim()
                    )
                )
            }
            _formState.value = _formState.value.copy(isSaved = true)
        }
    }
}
