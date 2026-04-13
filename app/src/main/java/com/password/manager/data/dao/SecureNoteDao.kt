package com.password.manager.data.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.password.manager.data.entity.SecureNoteEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface SecureNoteDao {

    @Query("SELECT * FROM secure_notes ORDER BY updatedAt DESC")
    fun getAll(): Flow<List<SecureNoteEntity>>

    @Query("SELECT * FROM secure_notes WHERE id = :id")
    fun getById(id: Long): Flow<SecureNoteEntity?>

    @Query("SELECT * FROM secure_notes WHERE title LIKE '%' || :query || '%' OR content LIKE '%' || :query || '%'")
    fun search(query: String): Flow<List<SecureNoteEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(note: SecureNoteEntity): Long

    @Update
    suspend fun update(note: SecureNoteEntity)

    @Delete
    suspend fun delete(note: SecureNoteEntity)

    @Query("DELETE FROM secure_notes WHERE id = :id")
    suspend fun deleteById(id: Long)

    @Query("DELETE FROM secure_notes")
    suspend fun deleteAll()
}
