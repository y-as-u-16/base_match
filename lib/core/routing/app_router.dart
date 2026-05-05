import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/games/presentation/pages/create_game_page.dart';
import '../../features/games/presentation/pages/game_detail_page.dart';
import '../../features/games/presentation/pages/games_page.dart';
import '../../features/games/presentation/pages/pitching_input_page.dart';
import '../../features/games/presentation/pages/plate_appearance_input_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/stats/presentation/pages/stats_page.dart';
import '../../l10n/generated/app_localizations.dart';

final isInitializedProvider = StateProvider<bool>((ref) => false);

CustomTransitionPage<void> _fadeTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage<void> _slideRightTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 240),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final isInitialized = ref.watch(isInitializedProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      if (!isInitialized) {
        if (state.matchedLocation != '/splash') return '/splash';
        return null;
      }
      if (state.matchedLocation == '/splash') return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            _fadeTransitionPage(key: state.pageKey, child: const SplashPage()),
      ),
      ShellRoute(
        builder: (context, state, child) => _ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => _fadeTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/games',
            pageBuilder: (context, state) => _fadeTransitionPage(
              key: state.pageKey,
              child: const GamesPage(),
            ),
            routes: [
              GoRoute(
                path: 'create',
                pageBuilder: (context, state) => _slideRightTransitionPage(
                  key: state.pageKey,
                  child: CreateGamePage(
                    initialDate: _parseCreateGameDate(state),
                  ),
                ),
              ),
              GoRoute(
                path: ':gameId',
                pageBuilder: (context, state) => _slideRightTransitionPage(
                  key: state.pageKey,
                  child: GameDetailPage(
                    gameId: state.pathParameters['gameId']!,
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'plate-appearances/new',
                    pageBuilder: (context, state) => _slideRightTransitionPage(
                      key: state.pageKey,
                      child: PlateAppearanceInputPage(
                        gameId: state.pathParameters['gameId']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'pitching/new',
                    pageBuilder: (context, state) => _slideRightTransitionPage(
                      key: state.pageKey,
                      child: PitchingInputPage(
                        gameId: state.pathParameters['gameId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/stats',
            pageBuilder: (context, state) => _fadeTransitionPage(
              key: state.pageKey,
              child: const StatsPage(),
            ),
          ),
        ],
      ),
    ],
  );
});

DateTime? _parseCreateGameDate(GoRouterState state) {
  final date = state.uri.queryParameters['date'];
  if (date == null) return null;

  final parsed = DateTime.tryParse(date);
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.96),
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.52),
            ),
          ),
        ),
        child: NavigationBar(
          height: 66,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIndex: _calculateSelectedIndex(context),
          onDestinationSelected: (index) => _onItemTapped(index, context),
          destinations: [
            NavigationDestination(
              selectedIcon: const Icon(Icons.home_rounded),
              icon: const Icon(Icons.home_outlined),
              label: l10n.navHome,
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.sports_baseball),
              icon: const Icon(Icons.sports_baseball_outlined),
              label: l10n.navRecord,
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.bar_chart_rounded),
              icon: const Icon(Icons.bar_chart_outlined),
              label: l10n.navStats,
            ),
          ],
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/games')) return 1;
    if (location.startsWith('/stats')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/games');
      case 2:
        context.go('/stats');
    }
  }
}
