import 'package:flutter_todos_bloc_hive/models/todo.dart';

abstract class TodosApi {
  const TodosApi();

  // Get all tasks
  Future<List<Todo>> getTodos();

  // Get task by id
  Todo? getTodoById({required String id});

  // Add new task
  Future<void> addTodo(Todo todo);

  // Delete task
  Future<void> deleteTodo(String id);
}
