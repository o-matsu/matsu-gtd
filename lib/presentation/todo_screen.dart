import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/data/task_repository.dart';
import 'package:matsu_gtd/model/status.dart';
import 'package:matsu_gtd/presentation/widgets/layout.dart';
import 'package:matsu_gtd/presentation/widgets/navigation_bar.dart';

class ToDoScreen extends ConsumerWidget {
  const ToDoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProvider = ref.read(taskRepositoryProvider);

    return CommonLayout(
      titleText: NavigationItem.toDo.name,
      stream: taskProvider.snapshots(Status.actionable),
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
                  onDismissed: () =>
                      taskProvider.updateStatus(task, status: Status.wip),
                ),
                children: [
                  SlidableAction(
                    onPressed: (context) =>
                        taskProvider.updateStatus(task, status: Status.wip),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    icon: Icons.check,
                    label: 'Action',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.7,
                dismissible: DismissiblePane(
                  onDismissed: () =>
                      taskProvider.updateStatus(task, status: Status.waiting),
                ),
                children: [
                  SlidableAction(
                    onPressed: (context) => taskProvider.updateStatus(task,
                        status: Status.nonActionable),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Colors.white,
                    icon: Icons.close,
                    label: 'Non Actionable',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      // TODO: 日付入力モーダル
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    icon: Icons.calendar_today_rounded,
                    label: 'Calendar',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      // TODO: Projectクラスに変換
                    },
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryFixedDim,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    icon: Icons.folder_open,
                    label: 'Project',
                  ),
                  SlidableAction(
                    onPressed: (context) =>
                        taskProvider.updateStatus(task, status: Status.waiting),
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    icon: Icons.hourglass_top_outlined,
                    label: 'Waiting',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                title: Text(task.title),
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
