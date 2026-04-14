import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/auth/auto_lock_manager.dart';
import '../core/kdbx/kdbx_service.dart';
import '../features/unlock/unlock_screen.dart';
import '../features/vault/vault_selector_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/entries/entry_detail_screen.dart';
import '../features/entries/entry_form_screen.dart';
import '../features/groups/group_manage_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/password_gen/password_generator_screen.dart';
import '../features/search/search_screen.dart';
import '../core/providers/settings_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final lockState = ref.watch(lockStateProvider);
  final kdbxService = ref.watch(kdbxServiceProvider);
  final onboardingComplete = ref.watch(onboardingCompleteProvider);
  final recentFiles = ref.watch(recentFilesProvider);

  // Controlla se esiste almeno un database recente su disco
  bool hasRecentDatabase() {
    for (final path in recentFiles) {
      if (File(path).existsSync()) return true;
    }
    return false;
  }

  return GoRouter(
    initialLocation: '/unlock',
    redirect: (context, state) {
      final isOnOnboarding = state.matchedLocation == '/onboarding';
      final isOnUnlock = state.matchedLocation == '/unlock';
      final isOnVault = state.matchedLocation == '/vault';

      // Prima volta: vai sempre a onboarding
      if (!onboardingComplete && !isOnOnboarding) {
        return '/onboarding';
      }

      // Onboarding già fatto ma sei sulla pagina onboarding
      if (onboardingComplete && isOnOnboarding) {
        if (!lockState) return '/home';
        // Se c'è un database recente, vai a unlock direttamente
        if (kdbxService.isOpen || hasRecentDatabase()) return '/unlock';
        return '/vault';
      }

      // Flusso normale lock/unlock (solo dopo onboarding)
      if (onboardingComplete) {
        if (lockState && !isOnUnlock && !isOnVault) {
          // Se c'è un database aperto o un database recente, vai a unlock
          if (kdbxService.isOpen || hasRecentDatabase()) return '/unlock';
          return '/vault';
        }
        if (!lockState && (isOnUnlock || isOnVault)) {
          return '/home';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/unlock',
        builder: (context, state) => const UnlockScreen(),
      ),
      GoRoute(
        path: '/vault',
        builder: (context, state) => const VaultSelectorScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'entry/:entryUuid',
            builder: (context, state) => EntryDetailScreen(
              entryUuid: state.pathParameters['entryUuid']!,
            ),
          ),
          GoRoute(
            path: 'entry-form',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return EntryFormScreen(
                entryUuid: extra?['entryUuid'] as String?,
                groupUuid: extra?['groupUuid'] as String?,
              );
            },
          ),
          GoRoute(
            path: 'groups',
            builder: (context, state) => const GroupManageScreen(),
          ),
          GoRoute(
            path: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'password-generator',
            builder: (context, state) => const PasswordGeneratorScreen(),
          ),
        ],
      ),
    ],
  );
});
