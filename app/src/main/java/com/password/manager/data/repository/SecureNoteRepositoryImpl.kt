package com.password.manager.data.repository

import com.password.manager.data.dao.SecureNoteDao
import com.password.manager.data.entity.SecureNoteEntity
import com.password.manager.domain.repository.SecureNoteRepository
import kotlinx.coroutines.flow.Flow

class SecureNoteRepositoryImpl(
    private val dao: SecureNoteDao
) : SecureNoteRepository {

    override fun getAll(): Flow<List<SecureNoteEntity>> = dao.getAll()

    override fun getById(id: Long): Flow<SecureNoteEntity?> = dao.getById(id)

    override fun search(query: String): Flow<List<SecureNoteEntity>> = dao.search(query)

    override suspend fun insert(note: SecureNoteEntity): Long = dao.insert(note)

    override suspend fun update(note: SecureNoteEntity) = dao.update(note)

    override suspend fun delete(note: SecureNoteEntity) = dao.delete(note)

    override suspend fun deleteById(id: Long) = dao.deleteById(id)

    override suspend fun deleteAll() = dao.deleteAll()
}
