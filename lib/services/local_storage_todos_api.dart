import 'package:flutter_todos_bloc_hive/models/todo.dart';
import 'package:flutter_todos_bloc_hive/services/todos_api.dart';
import 'package:hive_flutter/adapters.dart';

class LocalStorageTodosApi extends TodosApi {
  static const _boxName = "todo_storage_key";
  late final Box<Todo> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    _box = await Hive.openBox<Todo>(_boxName);
  }

  @override
  Future<List<Todo>> getTodos() async {
    // await Future.delayed(const Duration(seconds: 3));
    return _box.values.toList();
  }

  @override
  Todo? getTodoById({required String id}) {
    return _box.get(id);
  }

  @override
  Future<void> addTodo(Todo task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
  }
}
