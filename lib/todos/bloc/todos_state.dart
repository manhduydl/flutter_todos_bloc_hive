part of 'todos_bloc.dart';

enum TodosStatus { initial, loading, success, failure }

final class TodosState extends Equatable {
  const TodosState({
    this.status = TodosStatus.initial,
    this.todos = const [],
    this.shouldRemindTodo = false,
    this.searchQuery,
    this.numTodosDueToday = 0,
  });

  final TodosStatus status;
  final List<Todo> todos;
  final bool shouldRemindTodo;
  final String? searchQuery;
  final int numTodosDueToday;

  List<Todo> get filteredTodos => (searchQuery?.isEmpty ?? true)
      ? todos
      : todos.where((todo) => todo.title.trim().toLowerCase().contains(searchQuery!.trim().toLowerCase())).toList();

  TodosState copyWith({
    TodosStatus? status,
    List<Todo>? todos,
    bool? shouldRemindTodo,
    String? searchQuery,
    int? numTodosDueToday,
  }) {
    return TodosState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      shouldRemindTodo: shouldRemindTodo ?? false,
      searchQuery: searchQuery ?? this.searchQuery,
      numTodosDueToday: numTodosDueToday ?? this.numTodosDueToday,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        shouldRemindTodo,
        searchQuery,
      ];
}
