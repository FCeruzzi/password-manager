package com.password.manager.ui.navigation

sealed class Screen(val route: String) {
    data object Auth : Screen("auth")
    data object Home : Screen("home")

    // Account
    data object AccountList : Screen("accounts")
    data object AccountDetail : Screen("account/{accountId}") {
        fun createRoute(id: Long) = "account/$id"
    }
    data object AccountForm : Screen("account/form?accountId={accountId}") {
        fun createRoute(id: Long = 0L) = "account/form?accountId=$id"
    }

    // Credit Card
    data object CardList : Screen("cards")
    data object CardDetail : Screen("card/{cardId}") {
        fun createRoute(id: Long) = "card/$id"
    }
    data object CardForm : Screen("card/form?cardId={cardId}") {
        fun createRoute(id: Long = 0L) = "card/form?cardId=$id"
    }

    // Secure Note
    data object NoteList : Screen("notes")
    data object NoteDetail : Screen("note/{noteId}") {
        fun createRoute(id: Long) = "note/$id"
    }
    data object NoteForm : Screen("note/form?noteId={noteId}") {
        fun createRoute(id: Long = 0L) = "note/form?noteId=$id"
    }

    // Settings
    data object Settings : Screen("settings")
}
