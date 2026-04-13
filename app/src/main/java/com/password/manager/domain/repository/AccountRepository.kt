package com.password.manager.domain.repository

import com.password.manager.data.entity.AccountEntity
import kotlinx.coroutines.flow.Flow

interface AccountRepository {
    fun getAll(): Flow<List<AccountEntity>>
    fun getById(id: Long): Flow<AccountEntity?>
    fun search(query: String): Flow<List<AccountEntity>>
    suspend fun insert(account: AccountEntity): Long
    suspend fun update(account: AccountEntity)
    suspend fun delete(account: AccountEntity)
    suspend fun deleteById(id: Long)
    suspend fun deleteAll()
}
