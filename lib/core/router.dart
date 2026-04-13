import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/auth/auto_lock_manager.dart';
import '../core/kdbx/kdbx_service.dart';
import '../features/unlock/unlock_screen.dart';
import '../features/vault/vault_selector_screen.dart';
import '../features/home/home_screen.dart';
import '../features/entries/entry_detail_screen.dart';
import '../features/entries/entry_form_screen.dart';
import '../features/groups/group_manage_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/password_gen/password_generator_screen.dart';
import '../features/search/search_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final lockState = ref.watch(lockStateProvider);
  final kdbxService = ref.watch(kdbxServiceProvider);

  return GoRouter(
    initialLocation: '/unlock',
    redirect: (context, state) {
      final isLocked = lockState;
      final isOnUnlock = state.matchedLocation == '/unlock';
      final isOnVault = state.matchedLocation == '/vault';

      if (isLocked && !isOnUnlock && !isOnVault) {
        if (kdbxService.isOpen) return '/unlock';
        return '/vault';
      }

      if (!isLocked && isOnUnlock) return '/home';

      return null;
    },
    routes: [
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
