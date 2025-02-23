import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/data/task_repository.dart';
import 'package:matsu_gtd/model/status.dart';

class WipWatcher extends HookConsumerWidget {
  const WipWatcher({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProvider = ref.watch(taskRepositoryProvider);
    final wipTask = taskProvider.snapshots(Status.wip);

    return Column(
      children: [
        Expanded(child: child),
        StreamBuilder(
          stream: wipTask,
          builder: (context, snapshot) {
            if (!snapshot.hasError && snapshot.hasData) {
              if (snapshot.data!.docs.length > 1) {
                throw Exception('you have more than 2.');
                // TODO: 直近wipになったもの以外は、actionableに戻す
              }
            }
            final task = snapshot.data?.docs.firstOrNull?.data();
            return task != null
                ? Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.2,
                      children: [
                        SlidableAction(
                          onPressed: (context) => taskProvider
                              .updateStatus(task, status: Status.done),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          icon: Icons.check,
                          label: 'Done',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.2,
                      children: [
                        SlidableAction(
                          onPressed: (context) => taskProvider
                              .updateStatus(task, status: Status.actionable),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                          icon: Icons.pause,
                          label: 'Pause',
                        ),
                      ],
                    ),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.secondary,
                      title: Text(
                        task.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  )
                : Container();
          },
        ),
      ],
    );
  }
}
