import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../features/presentation/domain/presentation_content.dart';
import '../features/presentation/presentation/views/portfolio_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  GoRoute route(AppPage page) => GoRoute(
    path: page.path.split('/').last,
    builder: (context, state) => PortfolioScreen(page: page),
  );
  StatefulShellBranch branch(AppPage page, List<RouteBase> children) =>
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: page.path,
            builder: (context, state) => PortfolioScreen(page: page),
            routes: children,
          ),
        ],
      );
  final router = GoRouter(
    initialLocation: AppPage.welcome.path,
    routes: [
      GoRoute(
        path: AppPage.welcome.path,
        builder: (context, state) =>
            const PortfolioScreen(page: AppPage.welcome),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => NavigationShell(shell: shell),
        branches: [
          branch(AppPage.overview, []),
          branch(AppPage.profession, [
            route(AppPage.duties),
            route(AppPage.tradeoffs),
          ]),
          branch(AppPage.skills, []),
          branch(AppPage.learning, [
            route(AppPage.growth),
            route(AppPage.why),
            route(AppPage.stack),
          ]),
          branch(AppPage.profile, []),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => context.go(AppPage.overview.path),
          child: const Text('Вернуться к обзору'),
        ),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});

class NavigationShell extends StatelessWidget {
  const NavigationShell({super.key, required this.shell});
  final StatefulNavigationShell shell;
  static const destinations = [
    'Обзор',
    'Профессия',
    'Навыки',
    'Мой путь',
    'Профиль',
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    Expanded(
                      child: _NavItem(
                        index: i,
                        label: destinations[i],
                        selected: shell.currentIndex == i,
                        onTap: () => shell.goBranch(
                          i,
                          initialLocation: i == shell.currentIndex,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final int index;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    excludeSemantics: true,
    selected: selected,
    button: true,
    label: label,
    child: Material(
      color: selected ? AppColors.accent : AppColors.ink,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        key: ValueKey('nav-$index'),
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/nav_${index}_${selected ? 'on' : 'off'}.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  height: 1.2,
                  color: selected ? AppColors.ink : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
