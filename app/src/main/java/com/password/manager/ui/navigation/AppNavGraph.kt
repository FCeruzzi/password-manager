package com.password.manager.ui.navigation

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.password.manager.PasswordManagerApp
import com.password.manager.ui.accounts.AccountDetailScreen
import com.password.manager.ui.accounts.AccountFormScreen
import com.password.manager.ui.accounts.AccountFormViewModel
import com.password.manager.ui.accounts.AccountListScreen
import com.password.manager.ui.accounts.AccountViewModel
import com.password.manager.ui.auth.AuthScreen
import com.password.manager.ui.auth.AuthViewModel
import com.password.manager.ui.cards.CardDetailScreen
import com.password.manager.ui.cards.CardFormScreen
import com.password.manager.ui.cards.CardFormViewModel
import com.password.manager.ui.cards.CardListScreen
import com.password.manager.ui.cards.CardViewModel
import com.password.manager.ui.notes.NoteDetailScreen
import com.password.manager.ui.notes.NoteFormScreen
import com.password.manager.ui.notes.NoteFormViewModel
import com.password.manager.ui.notes.NoteListScreen
import com.password.manager.ui.notes.NoteViewModel
import com.password.manager.ui.settings.SettingsScreen
import com.password.manager.ui.settings.SettingsViewModel

@Composable
fun AppNavGraph() {
    val rootNavController = rememberNavController()
    val context = LocalContext.current
    val app = context.applicationContext as PasswordManagerApp

    // Check for auto-lock
    val lifecycleOwner = androidx.lifecycle.compose.LocalLifecycleOwner.current
    androidx.compose.runtime.DisposableEffect(lifecycleOwner) {
        val observer = androidx.lifecycle.LifecycleEventObserver { _, event ->
            if (event == androidx.lifecycle.Lifecycle.Event.ON_RESUME && app.lockRequested) {
                app.lockRequested = false
                rootNavController.navigate(Screen.Auth.route) {
                    popUpTo(0) { inclusive = true }
                }
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose { lifecycleOwner.lifecycle.removeObserver(observer) }
    }

    NavHost(
        navController = rootNavController,
        startDestination = Screen.Auth.route
    ) {
        composable(Screen.Auth.route) {
            val authViewModel: AuthViewModel = viewModel()
            AuthScreen(
                viewModel = authViewModel,
                onAuthenticated = {
                    rootNavController.navigate(Screen.Home.route) {
                        popUpTo(Screen.Auth.route) { inclusive = true }
                    }
                }
            )
        }
        composable(Screen.Home.route) {
            HomeScreenWithBottomNav(rootNavController)
        }
    }
}

@Composable
private fun HomeScreenWithBottomNav(
    rootNavController: androidx.navigation.NavHostController
) {
    val innerNavController = rememberNavController()
    val navBackStackEntry by innerNavController.currentBackStackEntryAsState()
    val currentRoute = navBackStackEntry?.destination?.route

    // Only show bottom bar on tab screens
    val showBottomBar = currentRoute in bottomNavItems.map { it.route }

    Scaffold(
        bottomBar = {
            if (showBottomBar) {
                NavigationBar {
                    bottomNavItems.forEach { item ->
                        NavigationBarItem(
                            icon = { Icon(item.icon, contentDescription = item.label) },
                            label = { Text(item.label, style = MaterialTheme.typography.labelSmall) },
                            selected = currentRoute == item.route,
                            onClick = {
                                innerNavController.navigate(item.route) {
                                    popUpTo(innerNavController.graph.findStartDestination().id) {
                                        saveState = true
                                    }
                                    launchSingleTop = true
                                    restoreState = true
                                }
                            }
                        )
                    }
                }
            }
        }
    ) { padding ->
        val context = LocalContext.current
        val app = context.applicationContext as PasswordManagerApp

        NavHost(
            navController = innerNavController,
            startDestination = Screen.AccountList.route,
            modifier = Modifier.padding(padding)
        ) {
            // ── Accounts ──
            composable(Screen.AccountList.route) {
                val vm: AccountViewModel = viewModel()
                AccountListScreen(
                    viewModel = vm,
                    onAccountClick = { id ->
                        innerNavController.navigate(Screen.AccountDetail.createRoute(id))
                    },
                    onAddClick = {
                        innerNavController.navigate(Screen.AccountForm.createRoute())
                    }
                )
            }
            composable(
                route = Screen.AccountDetail.route,
                arguments = listOf(navArgument("accountId") { type = NavType.LongType })
            ) { backStackEntry ->
                val accountId = backStackEntry.arguments?.getLong("accountId") ?: 0L
                val accountFlow = remember(accountId) {
                    app.accountRepository.getById(accountId)
                }
                AccountDetailScreen(
                    accountFlow = accountFlow,
                    onBack = { innerNavController.popBackStack() },
                    onEdit = { id ->
                        innerNavController.navigate(Screen.AccountForm.createRoute(id))
                    }
                )
            }
            composable(
                route = Screen.AccountForm.route,
                arguments = listOf(
                    navArgument("accountId") { type = NavType.LongType; defaultValue = 0L }
                )
            ) {
                val vm: AccountFormViewModel = viewModel()
                AccountFormScreen(
                    viewModel = vm,
                    onBack = { innerNavController.popBackStack() }
                )
            }

            // ── Cards ──
            composable(Screen.CardList.route) {
                val vm: CardViewModel = viewModel()
                CardListScreen(
                    viewModel = vm,
                    onCardClick = { id ->
                        innerNavController.navigate(Screen.CardDetail.createRoute(id))
                    },
                    onAddClick = {
                        innerNavController.navigate(Screen.CardForm.createRoute())
                    }
                )
            }
            composable(
                route = Screen.CardDetail.route,
                arguments = listOf(navArgument("cardId") { type = NavType.LongType })
            ) { backStackEntry ->
                val cardId = backStackEntry.arguments?.getLong("cardId") ?: 0L
                val cardFlow = remember(cardId) {
                    app.creditCardRepository.getById(cardId)
                }
                CardDetailScreen(
                    cardFlow = cardFlow,
                    onBack = { innerNavController.popBackStack() },
                    onEdit = { id ->
                        innerNavController.navigate(Screen.CardForm.createRoute(id))
                    }
                )
            }
            composable(
                route = Screen.CardForm.route,
                arguments = listOf(
                    navArgument("cardId") { type = NavType.LongType; defaultValue = 0L }
                )
            ) {
                val vm: CardFormViewModel = viewModel()
                CardFormScreen(
                    viewModel = vm,
                    onBack = { innerNavController.popBackStack() }
                )
            }

            // ── Notes ──
            composable(Screen.NoteList.route) {
                val vm: NoteViewModel = viewModel()
                NoteListScreen(
                    viewModel = vm,
                    onNoteClick = { id ->
                        innerNavController.navigate(Screen.NoteDetail.createRoute(id))
                    },
                    onAddClick = {
                        innerNavController.navigate(Screen.NoteForm.createRoute())
                    }
                )
            }
            composable(
                route = Screen.NoteDetail.route,
                arguments = listOf(navArgument("noteId") { type = NavType.LongType })
            ) { backStackEntry ->
                val noteId = backStackEntry.arguments?.getLong("noteId") ?: 0L
                val noteFlow = remember(noteId) {
                    app.secureNoteRepository.getById(noteId)
                }
                NoteDetailScreen(
                    noteFlow = noteFlow,
                    onBack = { innerNavController.popBackStack() },
                    onEdit = { id ->
                        innerNavController.navigate(Screen.NoteForm.createRoute(id))
                    }
                )
            }
            composable(
                route = Screen.NoteForm.route,
                arguments = listOf(
                    navArgument("noteId") { type = NavType.LongType; defaultValue = 0L }
                )
            ) {
                val vm: NoteFormViewModel = viewModel()
                NoteFormScreen(
                    viewModel = vm,
                    onBack = { innerNavController.popBackStack() }
                )
            }

            // ── Settings ──
            composable(Screen.Settings.route) {
                val vm: SettingsViewModel = viewModel()
                SettingsScreen(viewModel = vm)
            }
        }
    }
}
