import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends Equatable {
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

  Task({
    String? id,
    required this.title,
    this.note = "",
    DateTime? dueDate,
    this.isCompleted = false,
  })  : id = id ?? Uuid().v4(),
        dueDate = dueDate ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, note, dueDate, isCompleted];
}
