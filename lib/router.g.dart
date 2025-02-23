// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $appShellRouteData,
    ];

RouteBase get $appShellRouteData => StatefulShellRouteData.$route(
      factory: $AppShellRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          navigatorKey: InboxBranch.$navigatorKey,
          routes: [
            GoRouteData.$route(
              path: '/inbox',
              factory: $InboxRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          navigatorKey: ToDoBranch.$navigatorKey,
          routes: [
            GoRouteData.$route(
              path: '/toDo',
              factory: $ToDoRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $AppShellRouteDataExtension on AppShellRouteData {
  static AppShellRouteData _fromState(GoRouterState state) =>
      const AppShellRouteData();
}

extension $InboxRouteExtension on InboxRoute {
  static InboxRoute _fromState(GoRouterState state) => const InboxRoute();

  String get location => GoRouteData.$location(
        '/inbox',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ToDoRouteExtension on ToDoRoute {
  static ToDoRoute _fromState(GoRouterState state) => const ToDoRoute();

  String get location => GoRouteData.$location(
        '/toDo',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
