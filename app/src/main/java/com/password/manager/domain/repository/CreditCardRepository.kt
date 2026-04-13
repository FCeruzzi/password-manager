package com.password.manager.domain.repository

import com.password.manager.data.entity.CreditCardEntity
import kotlinx.coroutines.flow.Flow

interface CreditCardRepository {
    fun getAll(): Flow<List<CreditCardEntity>>
    fun getById(id: Long): Flow<CreditCardEntity?>
    fun search(query: String): Flow<List<CreditCardEntity>>
    suspend fun insert(card: CreditCardEntity): Long
    suspend fun update(card: CreditCardEntity)
    suspend fun delete(card: CreditCardEntity)
    suspend fun deleteById(id: Long)
    suspend fun deleteAll()
}
