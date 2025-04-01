part of 'todos_bloc.dart';

enum TodosStatus { initial, loading, success, failure }

final class TodosState extends Equatable {
  const TodosState({
    this.status = TodosStatus.initial,
    this.todos = const [],
    this.shouldRemindTodo = false,
    this.searchQuery,
  });

  final TodosStatus status;
  final List<Todo> todos;
  final bool shouldRemindTodo;
  final String? searchQuery;

  List<Todo> get filteredTodos => (searchQuery?.isEmpty ?? true)
      ? todos
      : todos.where((todo) => todo.title.trim().toLowerCase().contains(searchQuery!.trim().toLowerCase())).toList();

  TodosState copyWith({
    TodosStatus? status,
    List<Todo>? todos,
    bool? shouldRemindTodo,
    String? searchQuery,
  }) {
    return TodosState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      shouldRemindTodo: shouldRemindTodo ?? this.shouldRemindTodo,
      searchQuery: searchQuery ?? this.searchQuery,
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
