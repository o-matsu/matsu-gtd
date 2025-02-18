import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/data/task_repository.dart';
import 'package:matsu_gtd/model/task.dart';
import 'package:matsu_gtd/router.dart';

class CommonNavigationBar extends ConsumerWidget {
  const CommonNavigationBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProvider = ref.read(taskRepositoryProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
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
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          InboxRoute().go(context);
          taskProvider.add(Task());
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
