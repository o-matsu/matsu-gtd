import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:matsu_gtd/model/status.dart';

part 'task.freezed.dart';

@freezed
class Task with _$Task {
  const Task._();

  const factory Task({
    required String title,
    @Default(Status.inbox) Status status,
    @Default(false) bool isProject,
    @Default([]) List<String> children,
    DateTime? startedAt,
    DateTime? finishedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) = _Task;

  factory Task.fromFirebase(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    _,
  ) {
    final data = snapshot.data();
    return Task(
      title: data?['title'],
      updatedAt: (data?['updatedAt'] as Timestamp?)?.toDate(),
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> get toFirestore => {
        'title': title,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': createdAt as Timestamp? ?? FieldValue.serverTimestamp(),
      };
}
