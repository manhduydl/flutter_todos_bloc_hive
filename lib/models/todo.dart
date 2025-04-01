import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime? dueDate;
  @HiveField(3)
  bool isCompleted;

  Todo({
    String? id,
    required this.title,
    this.dueDate,
    this.isCompleted = false,
  }) : id = id ?? Uuid().v4();

  Todo copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
