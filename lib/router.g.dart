// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $inboxRoute,
    ];

RouteBase get $inboxRoute => GoRouteData.$route(
      path: '/inbox',
      factory: $InboxRouteExtension._fromState,
    );

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
