package com.password.manager.data.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.password.manager.data.entity.CreditCardEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface CreditCardDao {

    @Query("SELECT * FROM credit_cards ORDER BY updatedAt DESC")
    fun getAll(): Flow<List<CreditCardEntity>>

    @Query("SELECT * FROM credit_cards WHERE id = :id")
    fun getById(id: Long): Flow<CreditCardEntity?>

    @Query("SELECT * FROM credit_cards WHERE holderName LIKE '%' || :query || '%' OR circuit LIKE '%' || :query || '%'")
    fun search(query: String): Flow<List<CreditCardEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(card: CreditCardEntity): Long

    @Update
    suspend fun update(card: CreditCardEntity)

    @Delete
    suspend fun delete(card: CreditCardEntity)

    @Query("DELETE FROM credit_cards WHERE id = :id")
    suspend fun deleteById(id: Long)

    @Query("DELETE FROM credit_cards")
    suspend fun deleteAll()
}
