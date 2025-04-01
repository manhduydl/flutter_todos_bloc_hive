import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos_bloc_hive/utils/date_util.dart';

import '../../models/todo.dart';
import '../../services/todos_api.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosApi _todosApi;

  TodosBloc({required TodosApi todosApi})
      : _todosApi = todosApi,
        super(TodosState()) {
    on<TodosInitEvent>(_onTodosInitEvent);
    on<LoadTodosEvent>(_onLoadTodosEvent);
    on<TodoCompletionToggled>(_onTodoCompletionToggled);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodosSearchQueryChanged>(_onTodosSearchQueryChanged);
  }

  Future<void> _onLoadTodosEvent(
    LoadTodosEvent event,
    Emitter<TodosState> emit,
  ) async {
    final todos = await _todosApi.getTodos();
    print("_onLoadTodosEvent $todos");
    emit(state.copyWith(status: TodosStatus.success, todos: todos));
  }

  Future<void> _onTodosInitEvent(
    TodosInitEvent event,
    Emitter<TodosState> emit,
  ) async {
    final todos = await _todosApi.getTodos();
    emit(state.copyWith(shouldRemindTodo: _shouldRemindTodo(todos)));
    emit(state.copyWith(status: TodosStatus.success, todos: todos, shouldRemindTodo: false));
  }

  Future<void> _onTodoCompletionToggled(
    TodoCompletionToggled event,
    Emitter<TodosState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todosApi.addTodo(newTodo);
    add(LoadTodosEvent());
  }

  bool _shouldRemindTodo(List<Todo> todos) {
    final todoDueDateToday = todos.where((todo) {
      if (todo.dueDate != null && todo.isCompleted == false) {
        return todo.dueDate!.isSameDate(DateTime.now());
      }
      return false;
    });
    return todoDueDateToday.isNotEmpty;
  }

  FutureOr<void> _onTodoDeleted(TodoDeleted event, Emitter<TodosState> emit) {
    _todosApi.deleteTodo(event.todo.id);
  }

  FutureOr<void> _onTodosSearchQueryChanged(
    TodosSearchQueryChanged event,
    Emitter<TodosState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
