import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/games/presentation/pages/create_game_page.dart';
import '../../features/games/presentation/pages/game_detail_page.dart';
import '../../features/games/presentation/pages/plate_appearance_input_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/matchups/presentation/pages/matchup_detail_page.dart';
import '../../features/matchups/presentation/pages/matchup_list_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/share/presentation/pages/card_preview_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/teams/presentation/pages/create_team_page.dart';
import '../../features/teams/presentation/pages/join_team_page.dart';
import '../../features/teams/presentation/pages/team_detail_page.dart';

/// アプリ初期化完了フラグ。SplashPageの初期化完了後にtrueにする。
/// Phase 1 では Supabase 初期化は任意で、設定が無くてもtrueになる。
final isInitializedProvider = StateProvider<bool>((ref) => false);

/// フェード遷移を生成するヘルパー
CustomTransitionPage<void> _fadeTransitionPage({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 250),
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

/// ボトムアップスライド+フェード遷移を生成するヘルパー
CustomTransitionPage<void> _slideUpFadeTransitionPage({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 280),
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

/// スケール+フェード遷移を生成するヘルパー
CustomTransitionPage<void> _scaleFadeTransitionPage({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 280),
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scaleTween = Tween(begin: 0.92, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      return ScaleTransition(
        scale: animation.drive(scaleTween),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

/// 右からスライド遷移を生成するヘルパー（作成系画面用、やや高速）
CustomTransitionPage<void> _slideRightTransitionPage({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 250),
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final isInitialized = ref.watch(isInitializedProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      // 初期化完了前はスプラッシュに留まる
      if (!isInitialized) {
        if (state.matchedLocation != '/splash') return '/splash';
        return null;
      }

      // Phase 1: 認証ガードは撤去。スプラッシュ完了後はホームへ。
      // ログイン必須機能は AuthRequiredOverlay で画面側からロックする想定。
      if (state.matchedLocation == '/splash') {
        return '/';
      }
      return null;
    },
    routes: [
      // スプラッシュ画面
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey,
          child: const SplashPage(),
        ),
      ),
      // 認証画面: フェード
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/sign-up',
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey,
          child: const SignUpPage(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => _ScaffoldWithNavBar(child: child),
        routes: [
          // タブ画面: フェード
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => _fadeTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
            ),
          ),
          // タブ画面: フェード
          GoRoute(
            path: '/teams',
            pageBuilder: (context, state) => _fadeTransitionPage(
              key: state.pageKey,
              child: const CreateTeamPage(),
            ),
          ),
          // 作成系画面: 右からスライド
          GoRoute(
            path: '/teams/create',
            pageBuilder: (context, state) => _slideRightTransitionPage(
              key: state.pageKey,
              child: const CreateTeamPage(),
            ),
          ),
          GoRoute(
            path: '/teams/join',
            pageBuilder: (context, state) => _slideRightTransitionPage(
              key: state.pageKey,
              child: const JoinTeamPage(),
            ),
          ),
          // 詳細画面: ボトムアップ+フェード
          GoRoute(
            path: '/teams/:teamId',
            pageBuilder: (context, state) => _slideUpFadeTransitionPage(
              key: state.pageKey,
              child: TeamDetailPage(
                teamId: state.pathParameters['teamId']!,
              ),
            ),
          ),
          // 作成系画面: 右からスライド
          GoRoute(
            path: '/games/create',
            pageBuilder: (context, state) => _slideRightTransitionPage(
              key: state.pageKey,
              child: CreateGamePage(
                teamId: state.uri.queryParameters['teamId']!,
              ),
            ),
          ),
          // 詳細画面: ボトムアップ+フェード
          GoRoute(
            path: '/games/:gameId',
            pageBuilder: (context, state) => _slideUpFadeTransitionPage(
              key: state.pageKey,
              child: GameDetailPage(
                gameId: state.pathParameters['gameId']!,
              ),
            ),
            routes: [
              // 打席入力: 右からスライド
              GoRoute(
                path: 'plate-appearance',
                pageBuilder: (context, state) => _slideRightTransitionPage(
                  key: state.pageKey,
                  child: PlateAppearanceInputPage(
                    gameId: state.pathParameters['gameId']!,
                  ),
                ),
              ),
            ],
          ),
          // タブ画面: フェード
          GoRoute(
            path: '/matchups',
            pageBuilder: (context, state) => _fadeTransitionPage(
              key: state.pageKey,
              child: const MatchupListPage(),
            ),
          ),
          // 詳細画面: ボトムアップ+フェード
          GoRoute(
            path: '/matchups/:matchupType/:id1/:id2',
            pageBuilder: (context, state) => _slideUpFadeTransitionPage(
              key: state.pageKey,
              child: MatchupDetailPage(
                matchupType: state.pathParameters['matchupType']!,
                id1: state.pathParameters['id1']!,
                id2: state.pathParameters['id2']!,
              ),
            ),
          ),
          // カードプレビュー: スケール+フェード
          GoRoute(
            path: '/matchups/:matchupType/:id1/:id2/card',
            pageBuilder: (context, state) => _scaleFadeTransitionPage(
              key: state.pageKey,
              child: CardPreviewPage(
                matchupType: state.pathParameters['matchupType']!,
                id1: state.pathParameters['id1']!,
                id2: state.pathParameters['id2']!,
              ),
            ),
          ),
          // タブ画面: フェード
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => _fadeTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
            ),
            routes: [
              // プロフィール編集: ボトムアップ+フェード
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) => _slideUpFadeTransitionPage(
                  key: state.pageKey,
                  child: const EditProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sports_baseball), label: 'ホーム'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'チーム'),
          NavigationDestination(
              icon: Icon(Icons.local_fire_department), label: '因縁'),
          NavigationDestination(icon: Icon(Icons.person), label: 'プロフィール'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/matchups')) return 2;
    if (location.startsWith('/profile')) return 3;
    if (location.startsWith('/teams')) return 1;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/teams');
      case 2:
        context.go('/matchups');
      case 3:
        context.go('/profile');
    }
  }
}
