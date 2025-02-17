import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/controller/auth_controller.dart';
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
      appBar: AppBar(
        title: Text('Inbox'),
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

                  /// TODO: スライドで操作
                  /// https://pub.dev/packages/flutter_slidable

                  return ListTile(
                    title: Text(data.title),
                    subtitle: data.createdAt != null
                        ? Text(data.createdAt.toString())
                        : null,
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
