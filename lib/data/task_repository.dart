import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/core/firebase/firestore_repository.dart';
import 'package:matsu_gtd/model/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_repository.g.dart';

class TaskRepository {
  TaskRepository(FirebaseFirestore firestore)
      : _collection = firestore.collection('tasks').withConverter(
              fromFirestore: Task.fromFirebase,
              toFirestore: (Task task, _) => task.toFirestore,
            );

  final CollectionReference<Task> _collection;

  Stream<QuerySnapshot<Task>> snapshots() => _collection.snapshots();

  Future<DocumentReference<Task>> add(Task data) => _collection.add(data);
}

@riverpod
TaskRepository taskRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  return TaskRepository(firestore);
}
