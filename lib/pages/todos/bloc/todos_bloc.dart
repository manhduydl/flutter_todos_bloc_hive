import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos_bloc_hive/utils/date_util.dart';

import '../../../models/todo.dart';
import '../../../repository/todos_repository.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository _todosRepository;

  TodosBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(TodosState()) {
    on<TodosInitEvent>(_onTodosInitEvent);
    on<LoadTodosEvent>(_onLoadTodosEvent);
    on<TodoCompletionToggled>(_onTodoCompletionToggled);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodosSearchQueryChanged>(_onTodosSearchQueryChanged);
    on<TodosReminderCheck>(_onTodosReminderCheck);
    on<TodosFinishRemind>(_onTodosFinishRemind);
  }

  Future<void> _onLoadTodosEvent(
    LoadTodosEvent event,
    Emitter<TodosState> emit,
  ) async {
    emit(state.copyWith(status: TodosStatus.loading));
    // await Future.delayed(Duration(seconds: 3));
    final todos = await _todosRepository.getTodos();
    emit(state.copyWith(status: TodosStatus.success, todos: todos));
  }

  Future<void> _onTodosInitEvent(
    TodosInitEvent event,
    Emitter<TodosState> emit,
  ) async {
    final todos = await _todosRepository.getTodos();
    final numTodosDueToday = _numTodosDueToday(todos);
    emit(state.copyWith(shouldRemindTodo: numTodosDueToday > 0, numTodosDueToday: numTodosDueToday));
    emit(state.copyWith(status: TodosStatus.success, todos: todos));
  }

  Future<void> _onTodoCompletionToggled(
    TodoCompletionToggled event,
    Emitter<TodosState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todosRepository.addTodo(newTodo);
    add(LoadTodosEvent());
  }

  Future<void> _onTodoDeleted(TodoDeleted event, Emitter<TodosState> emit) async {
    await _todosRepository.deleteTodo(event.todo.id);
    add(LoadTodosEvent());
  }

  FutureOr<void> _onTodosSearchQueryChanged(
    TodosSearchQueryChanged event,
    Emitter<TodosState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onTodosReminderCheck(TodosReminderCheck event, Emitter<TodosState> emit) async {
    final todos = await _todosRepository.getTodos();
    final numTodosDueToday = _numTodosDueToday(todos);
    emit(state.copyWith(shouldRemindTodo: numTodosDueToday > 0, numTodosDueToday: numTodosDueToday));
  }

  FutureOr<void> _onTodosFinishRemind(TodosFinishRemind event, Emitter<TodosState> emit) {
    emit(state.copyWith(shouldRemindTodo: false));
  }

  // Private method
  int _numTodosDueToday(List<Todo> todos) {
    final todoDueDateToday = todos.where((todo) {
      if (todo.dueDate != null && todo.isCompleted == false) {
        return todo.dueDate!.isSameDate(DateTime.now());
      }
      return false;
    });
    return todoDueDateToday.length;
  }
}
