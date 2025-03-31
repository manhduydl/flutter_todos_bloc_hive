import 'package:flutter_todos_bloc_hive/models/task.dart';

abstract class TodosApi {
  const TodosApi();

  // Get all tasks
  Future<List<Task>> getTasks();

  // Get task by id
  Task? getTaskById({required String id});

  // Add new task
  Future<void> addTask(Task task);

  // Delete task
  Future<void> deleteTask(String id);
}
