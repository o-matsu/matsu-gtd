import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matsu_gtd/presentation/inbox_screen.dart';

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

/// TODO: 認証ガードの実装
/// 認証してなければ、匿名ユーザーとしてログイン
/// https://zenn.dev/joo_hashi/articles/9e2eb6fdaf5d1b
/// https://medium.com/@jakob.prossinger/flutter-firebase-authentication-with-riverpod-2-5-and-gorouter-0311ad23550b
