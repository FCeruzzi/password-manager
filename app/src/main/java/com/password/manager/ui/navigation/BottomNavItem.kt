package com.password.manager.ui.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CreditCard
import androidx.compose.material.icons.automirrored.filled.Note
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Settings
import androidx.compose.ui.graphics.vector.ImageVector

data class BottomNavItem(
    val label: String,
    val icon: ImageVector,
    val route: String
)

val bottomNavItems = listOf(
    BottomNavItem("Account", Icons.Default.Person, Screen.AccountList.route),
    BottomNavItem("Carte", Icons.Default.CreditCard, Screen.CardList.route),
    BottomNavItem("Note", Icons.AutoMirrored.Filled.Note, Screen.NoteList.route),
    BottomNavItem("Impostazioni", Icons.Default.Settings, Screen.Settings.route)
)
