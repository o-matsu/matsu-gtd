import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/data/task_repository.dart';
import 'package:matsu_gtd/model/status.dart';
import 'package:matsu_gtd/model/task.dart';
import 'package:matsu_gtd/presentation/widgets/layout.dart';
import 'package:matsu_gtd/presentation/widgets/navigation_bar.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProvider = ref.read(taskRepositoryProvider);

    return CommonLayout(
      titleText: NavigationItem.inbox.name,
      stream: taskProvider.snapshots(Status.inbox),
      builder: (context, docs) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final task = doc.data();
            return Slidable(
              key: ValueKey(task.id!),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.2,
                dismissible: DismissiblePane(
                  dismissThreshold: 0.1,
                  onDismissed: () => taskProvider.updateStatus(task,
                      status: Status.actionable),
                ),
                children: [
                  SlidableAction(
                    onPressed: (context) => taskProvider.updateStatus(task,
                        status: Status.actionable),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    icon: Icons.check,
                    label: 'Actionable',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.2,
                dismissible: DismissiblePane(
                  dismissThreshold: 0.1,
                  onDismissed: () => taskProvider.updateStatus(task,
                      status: Status.nonActionable),
                ),
                children: [
                  SlidableAction(
                    onPressed: (context) => taskProvider.updateStatus(task,
                        status: Status.actionable),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Colors.white,
                    icon: Icons.inventory_2_outlined,
                    label: 'Archive',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                title: TextFormField(
                  key: Key(task.id!),
                  autofocus: task.title.isEmpty,
                  initialValue: task.title,
                  onChanged: (value) {
                    taskProvider.updateTitle(
                      task,
                      title: value,
                    );
                  },
                  onFieldSubmitted: (value) {
                    if (value.isEmpty) {
                      taskProvider.delete(id: task.id!);
                    } else {
                      taskProvider.add(Task());
                    }
                  },
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(height: 0);
          },
        );
      },
    );
  }
}
