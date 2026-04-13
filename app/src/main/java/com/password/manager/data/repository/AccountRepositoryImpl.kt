package com.password.manager.data.repository

import com.password.manager.data.dao.AccountDao
import com.password.manager.data.entity.AccountEntity
import com.password.manager.domain.repository.AccountRepository
import kotlinx.coroutines.flow.Flow

class AccountRepositoryImpl(
    private val dao: AccountDao
) : AccountRepository {

    override fun getAll(): Flow<List<AccountEntity>> = dao.getAll()

    override fun getById(id: Long): Flow<AccountEntity?> = dao.getById(id)

    override fun search(query: String): Flow<List<AccountEntity>> = dao.search(query)

    override suspend fun insert(account: AccountEntity): Long = dao.insert(account)

    override suspend fun update(account: AccountEntity) = dao.update(account)

    override suspend fun delete(account: AccountEntity) = dao.delete(account)

    override suspend fun deleteById(id: Long) = dao.deleteById(id)

    override suspend fun deleteAll() = dao.deleteAll()
}
