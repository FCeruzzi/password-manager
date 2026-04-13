package com.password.manager.domain.repository

import com.password.manager.data.entity.SecureNoteEntity
import kotlinx.coroutines.flow.Flow

interface SecureNoteRepository {
    fun getAll(): Flow<List<SecureNoteEntity>>
    fun getById(id: Long): Flow<SecureNoteEntity?>
    fun search(query: String): Flow<List<SecureNoteEntity>>
    suspend fun insert(note: SecureNoteEntity): Long
    suspend fun update(note: SecureNoteEntity)
    suspend fun delete(note: SecureNoteEntity)
    suspend fun deleteById(id: Long)
    suspend fun deleteAll()
}
