package com.password.manager.data.repository

import com.password.manager.data.dao.CreditCardDao
import com.password.manager.data.entity.CreditCardEntity
import com.password.manager.domain.repository.CreditCardRepository
import kotlinx.coroutines.flow.Flow

class CreditCardRepositoryImpl(
    private val dao: CreditCardDao
) : CreditCardRepository {

    override fun getAll(): Flow<List<CreditCardEntity>> = dao.getAll()

    override fun getById(id: Long): Flow<CreditCardEntity?> = dao.getById(id)

    override fun search(query: String): Flow<List<CreditCardEntity>> = dao.search(query)

    override suspend fun insert(card: CreditCardEntity): Long = dao.insert(card)

    override suspend fun update(card: CreditCardEntity) = dao.update(card)

    override suspend fun delete(card: CreditCardEntity) = dao.delete(card)

    override suspend fun deleteById(id: Long) = dao.deleteById(id)

    override suspend fun deleteAll() = dao.deleteAll()
}
