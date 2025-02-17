import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/core/utils/scaffold.dart';
import 'package:matsu_gtd/model/task.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = FirebaseFirestore.instance;
    final tasks = db
        .collection('tasks')
        .withConverter(
          fromFirestore: Task.fromFirebase,
          toFirestore: (Task task, _) => task.toFirestore,
        )
        .snapshots();
    return Scaffold(
      body: StreamBuilder(
        stream: tasks,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  final data = document.data() as Task;
                  return Slidable(
                    key: ValueKey(data.title),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        print('go to next action');
                      }),
                      children: [
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          icon: Icons.check,
                          label: 'Next Action',
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: TextFormField(initialValue: data.title),
                      subtitle: data.createdAt != null
                          ? Text(data.createdAt.toString())
                          : null,
                    ),
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: true,
                    onFieldSubmitted: (value) {
                      debugPrint(value);
                      final task = Task(title: value);

                      db
                          .collection("tasks")
                          .withConverter(
                            fromFirestore: Task.fromFirebase,
                            toFirestore: (Task task, _) => task.toFirestore,
                          )
                          .add(task)
                          .then((DocumentReference doc) {
                        scaffold.currentState?.showSnackBar(
                          SnackBar(
                            content: Text('Task added.'),
                            showCloseIcon: true,
                          ),
                        );
                        if (!context.mounted) return;
                        context.pop();
                      });
                    },
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
