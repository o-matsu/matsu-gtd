import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/data/task_repository.dart';
import 'package:matsu_gtd/model/task.dart';
import 'package:matsu_gtd/router.dart';

enum NavigationItem {
  inbox(Icons.inbox),
  toDo(Icons.task_alt),
  projects(Icons.folder_open),
  archive(Icons.inventory_2_outlined),
  ;

  final IconData icon;
  const NavigationItem(this.icon);
}

class CommonNavigationBar extends ConsumerWidget {
  const CommonNavigationBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProvider = ref.read(taskRepositoryProvider);

    void submit() {
      InboxRoute().go(context);
      taskProvider.add(Task());
    }

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 450;

      return isMobile
          ? _MobileNavigation(navigationShell, onSubmitted: submit)
          : _DesktopNavigation(navigationShell, onSubmitted: submit);
    });
  }
}

class _MobileNavigation extends StatelessWidget {
  const _MobileNavigation(
    this.navigationShell, {
    required this.onSubmitted,
  });

  final StatefulNavigationShell navigationShell;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: NavigationItem.values
            .map(
              (e) => NavigationDestination(
                icon: Icon(e.icon),
                label: e.name,
              ),
            )
            .toList(),
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSubmitted,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _DesktopNavigation extends StatelessWidget {
  const _DesktopNavigation(
    this.navigationShell, {
    required this.onSubmitted,
  });

  final StatefulNavigationShell navigationShell;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            labelType: NavigationRailLabelType.all,
            destinations: NavigationItem.values
                .map((e) => NavigationRailDestination(
                      icon: Icon(e.icon),
                      label: Text(e.name),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: navigationShell),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSubmitted,
        child: Icon(Icons.add),
      ),
    );
  }
}
