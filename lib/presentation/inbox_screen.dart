import 'package:cloud_firestore/cloud_firestore.dart';
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

    return CommonLayout<Task>(
      titleText: NavigationItem.inbox.name,
      stream: taskProvider.snapshots(Status.inbox),
      builder: (context, docs) {
        return ReorderableListView.builder(
          buildDefaultDragHandles: false,
          padding: EdgeInsets.zero,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final task = docs[index].data();
            return InboxTile(
              key: Key(task.id!),
              index: index,
              task: task,
            );
          },
          onReorder: (int oldIndex, int newIndex) async {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final QueryDocumentSnapshot<Task> tmp = docs.removeAt(oldIndex);
            docs.insert(newIndex, tmp);
            await taskProvider.updateIndex(docs);
          },
        );
      },
    );
  }
}

class InboxTile extends ConsumerWidget {
  const InboxTile({
    super.key,
    required this.index,
    required this.task,
  });

  final int index;
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProvider = ref.read(taskRepositoryProvider);
    return Slidable(
      key: ValueKey(task.id!),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,
        dismissible: DismissiblePane(
          dismissThreshold: 0.1,
          onDismissed: () =>
              taskProvider.updateStatus(task, status: Status.actionable),
        ),
        children: [
          SlidableAction(
            onPressed: (context) =>
                taskProvider.updateStatus(task, status: Status.actionable),
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
          onDismissed: () =>
              taskProvider.updateStatus(task, status: Status.nonActionable),
        ),
        children: [
          SlidableAction(
            onPressed: (context) =>
                taskProvider.updateStatus(task, status: Status.actionable),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.inventory_2_outlined,
            label: 'Archive',
          ),
        ],
      ),
      child: ListTile(
        key: Key(task.id!),
        // contentPadding: EdgeInsets.symmetric(
        //   horizontal: 24,
        //   vertical: 8,
        // ),
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle),
        ),
        subtitle: task.projectId != null
            ? Row(
                children: [
                  IconButton(
                      onPressed: () {
                        // TODO: select project
                      },
                      icon: Icon(Icons.folder_open)),
                  Text(task.projectId!),
                ],
              )
            : null,
        title: TextFormField(
          key: Key(task.id!),
          autofocus: task.name.isEmpty,
          initialValue: task.name,
          onChanged: (value) {
            taskProvider.updateName(
              task,
              name: value,
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
  }
}
