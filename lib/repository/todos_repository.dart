import 'package:flutter_todos_bloc_hive/models/todo.dart';

import '../services/todos_api.dart';

class TodosRepository {
  const TodosRepository({
    required TodosApi todosApi,
  }) : _todosApi = todosApi;

  final TodosApi _todosApi;

  /// Receive list [todos] from API, sort and return it
  Future<List<Todo>> getTodos() async {
    List<Todo> todos = await _todosApi.getTodos();
    todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return todos;
  }

  Future<void> saveTodo(Todo todo) => _todosApi.addTodo(todo);

  Future<void> deleteTodo(String id) => _todosApi.deleteTodo(id);

  /// Disposes any resources managed by the repository.
  void dispose() => _todosApi.close();
}
