import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonNavigationBar extends StatelessWidget {
  const CommonNavigationBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
