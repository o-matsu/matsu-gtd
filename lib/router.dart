import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matsu_gtd/features/inbox/inbox_screen.dart';

part 'router.g.dart';

@TypedGoRoute<InboxRoute>(
  path: InboxRoute.path,
  routes: [],
)
class InboxRoute extends GoRouteData {
  const InboxRoute();

  static const String path = '/inbox';

  @override
  Widget build(context, state) => InboxScreen();
}

final router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/inbox',
);
