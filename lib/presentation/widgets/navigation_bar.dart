import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/controller/auth_controller.dart';

class CommonLayout extends ConsumerWidget {
  const CommonLayout({
    super.key,
    required this.titleText,
    required this.navigationShell,
  });

  final String? titleText;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: titleText != null ? Text(titleText!) : null,
        actions: [
          IconButton(
            onPressed: () {
              final auth = ref.read(authControllerProvider.notifier);
              auth.signInWithGoogle();
            },
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt),
            label: 'ToDo',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Archive',
          ),
        ],
      ),
    );
  }
}
