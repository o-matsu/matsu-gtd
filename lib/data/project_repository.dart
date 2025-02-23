import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/core/firebase/auth_repository.dart';
import 'package:matsu_gtd/core/firebase/firestore_repository.dart';
import 'package:matsu_gtd/model/project.dart';
import 'package:matsu_gtd/model/status.dart';
import 'package:matsu_gtd/model/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_repository.g.dart';

class ProjectRepository {
  ProjectRepository(this.user, this.firestore)
      : _collection = firestore
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .withConverter(
              fromFirestore: Project.fromFirebase,
              toFirestore: (Project project, _) => project.toFirestore,
            );

  final User user;
  final FirebaseFirestore firestore;
  final CollectionReference<Project> _collection;

  Query<Project> get _ordered => _collection
      .orderBy(
        'index',
      )
      .orderBy('createdAt');
  DocumentReference<Project> _doc(String id) => _collection.doc(id);

  Future<void> updateName(Project task, {required String name}) =>
      _doc(task.id!).set(task.copyWith(
        name: name,
      ));

  Future<void> delete({required String id}) => _doc(id).delete();

  Stream<QuerySnapshot<Project>> snapshots() => _ordered.snapshots();

  Future<DocumentReference<Project>> add(Project data) => _collection.add(data);

  Future<void> updateIndex(List<QueryDocumentSnapshot<Task>> tasks) async {
    final batch = firestore.batch();
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
ProjectRepository projectRepository(Ref ref) {
  final user = ref.watch(authRepositoryProvider);
  if (user.currentUser == null) throw Exception('not find user.');
  final firestore = ref.watch(firestoreProvider);
  return ProjectRepository(user.currentUser!, firestore);
}
