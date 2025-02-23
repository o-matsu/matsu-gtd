import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:matsu_gtd/model/status.dart';

part 'task.freezed.dart';

@freezed
class Task with _$Task {
  const Task._();

  const factory Task({
    String? id,
    @Default('') String title,
    @Default(Status.inbox) Status status,
    @Default(9999999999) int index,
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
    final pending = snapshot.metadata.hasPendingWrites;
    return Task(
      id: snapshot.id,
      title: data?['title'],
      updatedAt: pending
          ? DateTime.now()
          : (data?['updatedAt'] as Timestamp?)?.toDate(),
      createdAt: pending
          ? DateTime.now()
          : (data?['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> get toFirestore => {
        'title': title,
        'status': status.name,
        'index': index,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };
}
