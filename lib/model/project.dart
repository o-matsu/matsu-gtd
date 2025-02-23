import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:matsu_gtd/model/task.dart';

part 'project.freezed.dart';

@freezed
class Project with _$Project {
  const Project._();

  const factory Project({
    String? id,
    @Default('') String name,
    @Default(9999999999) int index,
    @Default([]) List<String> children,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) = _Project;

  factory Project.fromFirebase(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    _,
  ) {
    final data = snapshot.data();
    final pending = snapshot.metadata.hasPendingWrites;
    return Project(
      id: snapshot.id,
      name: data?['name'],
      children: data?['children'],
      updatedAt: pending
          ? DateTime.now()
          : (data?['updatedAt'] as Timestamp?)?.toDate(),
      createdAt: pending
          ? DateTime.now()
          : (data?['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> get toFirestore => {
        'name': name,
        'index': index,
        'children': children,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  factory Project.fromTask(
    Task task,
    _,
  ) {
    return Project(
      name: task.name,
    );
  }
}
