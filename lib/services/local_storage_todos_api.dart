import 'package:flutter_todos_bloc_hive/models/task.dart';
import 'package:flutter_todos_bloc_hive/services/todos_api.dart';
import 'package:hive_flutter/adapters.dart';

class LocalStorageTodosApi extends TodosApi {
  static const _boxName = "task_storage_key";
  late final Box<Task> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    _box = await Hive.openBox<Task>(_boxName);
  }

  @override
  Future<List<Task>> getTasks() async {
    // await Future.delayed(const Duration(seconds: 3));
    return _box.values.toList();
  }

  @override
  Task? getTaskById({required String id}) {
    return _box.get(id);
  }

  @override
  Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
