import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String note;
  @HiveField(3)
  DateTime dueDate;
  @HiveField(4)
  bool isCompleted;

  Task(
      {required this.id,
      required this.title,
      required this.note,
      required this.dueDate,
      required this.isCompleted});

  factory Task.create({
    required String? title,
    required String? note,
    DateTime? dueDate,
  }) =>
      Task(
        id: const Uuid().v4(),
        title: title ?? "",
        note: note ?? "",
        dueDate: dueDate ?? DateTime.now(),
        isCompleted: false,
      );
}
