import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/core/firebase/auth_repository.dart';
import 'package:matsu_gtd/core/firebase/firestore_repository.dart';
import 'package:matsu_gtd/model/project.dart';
import 'package:matsu_gtd/model/status.dart';
import 'package:matsu_gtd/model/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_repository.g.dart';

class TaskRepository {
  TaskRepository(this.user, this._firestore)
      : _collection = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .withConverter(
              fromFirestore: Task.fromFirebase,
              toFirestore: (Task task, _) => task.toFirestore,
            );

  final User user;
  final FirebaseFirestore _firestore;
  final CollectionReference<Task> _collection;

  Query<Task> _whereStatus(Status status) =>
      _ordered.where("status", isEqualTo: status.name);
  Query<Task> _whereProject(Project project) =>
      _ordered.where("projectId", isEqualTo: project.id);

  Query<Task> get _ordered => _collection
      .orderBy(
        'index',
      )
      .orderBy('createdAt');

  DocumentReference<Task> _doc(String id) => _collection.doc(id);

  Future<void> updateName(Task task, {required String name}) =>
      _doc(task.id!).set(task.copyWith(
        name: name,
      ));
  Future<void> updateStatus(Task task, {required Status status}) =>
      _doc(task.id!).set(task.copyWith(
        status: status,
      ));

  Future<void> delete({required String id}) => _doc(id).delete();

  Stream<QuerySnapshot<Task>> snapshotsByStatus(Status status) =>
      _whereStatus(status).snapshots();
  Stream<QuerySnapshot<Task>> snapshotsByProject(Project project) =>
      _whereProject(project).snapshots();

  Future<DocumentReference<Task>> add(Task data) => _collection.add(data);

  Future<void> updateIndex(List<QueryDocumentSnapshot<Task>> tasks) async {
    final batch = _firestore.batch();
    tasks.asMap().forEach((index, todo) {
      batch.update(
        _doc(todo.id),
        {
          "index": index,
        },
      );
    });
    return batch.commit();
  }
}

@riverpod
TaskRepository taskRepository(Ref ref) {
  final user = ref.watch(authRepositoryProvider);
  if (user.currentUser == null) throw Exception('not find user.');
  final firestore = ref.watch(firestoreProvider);
  return TaskRepository(user.currentUser!, firestore);
}
