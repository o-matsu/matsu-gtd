import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matsu_gtd/core/utils/scaffold.dart';
import 'package:matsu_gtd/model/task.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  // TODO： freezedで型定義
                  // Map<String, dynamic> data =
                  //     document.data()! as Map<String, dynamic>;
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
                      // Create a new user with a first and last name
                      final task = Task(title: value);

                      // Add a new document with a generated ID
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'ToDo',
          ),
          NavigationDestination(
            icon: Icon(Icons.tab),
            label: 'Projects',
          ),
        ],
      ),
    );
  }
}
