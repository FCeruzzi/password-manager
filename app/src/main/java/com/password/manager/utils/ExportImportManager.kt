package com.password.manager.utils

import android.content.Context
import android.net.Uri
import com.password.manager.data.entity.AccountEntity
import com.password.manager.data.entity.CreditCardEntity
import com.password.manager.data.entity.SecureNoteEntity
import com.password.manager.domain.repository.AccountRepository
import com.password.manager.domain.repository.CreditCardRepository
import com.password.manager.domain.repository.SecureNoteRepository
import kotlinx.coroutines.flow.first
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

@Serializable
data class ExportData(
    val version: Int = 1,
    val exportedAt: Long = System.currentTimeMillis(),
    val accounts: List<AccountExport> = emptyList(),
    val creditCards: List<CreditCardExport> = emptyList(),
    val secureNotes: List<SecureNoteExport> = emptyList()
)

@Serializable
data class AccountExport(
    val title: String,
    val username: String,
    val password: String,
    val url: String = "",
    val notes: String = "",
    val createdAt: Long = 0,
    val updatedAt: Long = 0
)

@Serializable
data class CreditCardExport(
    val holderName: String,
    val cardNumber: String,
    val expiryDate: String,
    val cvv: String,
    val circuit: String,
    val pin: String = "",
    val createdAt: Long = 0,
    val updatedAt: Long = 0
)

@Serializable
data class SecureNoteExport(
    val title: String,
    val content: String,
    val createdAt: Long = 0,
    val updatedAt: Long = 0
)

class ExportImportManager(
    private val accountRepository: AccountRepository,
    private val creditCardRepository: CreditCardRepository,
    private val secureNoteRepository: SecureNoteRepository
) {

    private val json = Json {
        prettyPrint = true
        ignoreUnknownKeys = true
    }

    suspend fun exportToUri(context: Context, uri: Uri, password: String) {
        val accounts = accountRepository.getAll().first()
        val cards = creditCardRepository.getAll().first()
        val notes = secureNoteRepository.getAll().first()

        val exportData = ExportData(
            accounts = accounts.map { it.toExport() },
            creditCards = cards.map { it.toExport() },
            secureNotes = notes.map { it.toExport() }
        )

        val jsonString = json.encodeToString(ExportData.serializer(), exportData)
        val encrypted = CryptoManager.encrypt(jsonString.toByteArray(Charsets.UTF_8), password)

        context.contentResolver.openOutputStream(uri)?.use { it.write(encrypted) }
    }

    suspend fun importFromUri(context: Context, uri: Uri, password: String): ImportResult {
        val encrypted = context.contentResolver.openInputStream(uri)?.use { it.readBytes() }
            ?: return ImportResult(success = false, error = "Impossibile leggere il file")

        val decrypted = try {
            CryptoManager.decrypt(encrypted, password)
        } catch (_: Exception) {
            return ImportResult(success = false, error = "Password errata o file corrotto")
        }

        val exportData = try {
            json.decodeFromString(ExportData.serializer(), String(decrypted, Charsets.UTF_8))
        } catch (_: Exception) {
            return ImportResult(success = false, error = "Formato dati non valido")
        }

        var accountsImported = 0
        var cardsImported = 0
        var notesImported = 0

        for (account in exportData.accounts) {
            accountRepository.insert(account.toEntity())
            accountsImported++
        }
        for (card in exportData.creditCards) {
            creditCardRepository.insert(card.toEntity())
            cardsImported++
        }
        for (note in exportData.secureNotes) {
            secureNoteRepository.insert(note.toEntity())
            notesImported++
        }

        return ImportResult(
            success = true,
            accountsImported = accountsImported,
            cardsImported = cardsImported,
            notesImported = notesImported
        )
    }

    // Entity -> Export mappings
    private fun AccountEntity.toExport() = AccountExport(
        title = title, username = username, password = password,
        url = url, notes = notes, createdAt = createdAt, updatedAt = updatedAt
    )

    private fun CreditCardEntity.toExport() = CreditCardExport(
        holderName = holderName, cardNumber = cardNumber, expiryDate = expiryDate,
        cvv = cvv, circuit = circuit, pin = pin, createdAt = createdAt, updatedAt = updatedAt
    )

    private fun SecureNoteEntity.toExport() = SecureNoteExport(
        title = title, content = content, createdAt = createdAt, updatedAt = updatedAt
    )

    // Export -> Entity mappings (new IDs, preserve timestamps)
    private fun AccountExport.toEntity() = AccountEntity(
        title = title, username = username, password = password,
        url = url, notes = notes, createdAt = createdAt, updatedAt = updatedAt
    )

    private fun CreditCardExport.toEntity() = CreditCardEntity(
        holderName = holderName, cardNumber = cardNumber, expiryDate = expiryDate,
        cvv = cvv, circuit = circuit, pin = pin, createdAt = createdAt, updatedAt = updatedAt
    )

    private fun SecureNoteExport.toEntity() = SecureNoteEntity(
        title = title, content = content, createdAt = createdAt, updatedAt = updatedAt
    )
}

data class ImportResult(
    val success: Boolean,
    val error: String? = null,
    val accountsImported: Int = 0,
    val cardsImported: Int = 0,
    val notesImported: Int = 0
) {
    val summary: String
        get() = if (success) {
            "Importati: $accountsImported account, $cardsImported carte, $notesImported note"
        } else {
            error ?: "Errore sconosciuto"
        }
}
