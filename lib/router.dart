import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matsu_gtd/presentation/inbox_screen.dart';
import 'package:matsu_gtd/presentation/widgets/navigation_bar.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final inboxNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'inbox');

@TypedStatefulShellRoute<AppShellRouteData>(
    branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
      TypedStatefulShellBranch<InboxBranch>(
        routes: [
          TypedGoRoute<InboxRoute>(
            path: '/inbox',
          ),
        ],
      ),
    ])
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return CommonNavigationBar(
      navigationShell: navigationShell,
    );
  }
}

class InboxBranch extends StatefulShellBranchData {
  const InboxBranch();

  static final GlobalKey<NavigatorState> $navigatorKey = inboxNavigatorKey;
}

class InboxRoute extends GoRouteData {
  const InboxRoute();

  @override
  Widget build(context, state) => InboxScreen();
}

final router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/inbox',
);

/// TODO: 認証ガードの実装
/// 認証してなければ、匿名ユーザーとしてログイン
/// https://zenn.dev/joo_hashi/articles/9e2eb6fdaf5d1b
/// https://medium.com/@jakob.prossinger/flutter-firebase-authentication-with-riverpod-2-5-and-gorouter-0311ad23550b
