part of 'todos_bloc.dart';

sealed class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class TodosInitEvent extends TodosEvent {}

class LoadTodosEvent extends TodosEvent {}

final class TodoCompletionToggled extends TodosEvent {
  const TodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final Todo todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo, isCompleted];
}

final class TodoDeleted extends TodosEvent {
  const TodoDeleted(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

class TodosSearchQueryChanged extends TodosEvent {
  const TodosSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class TodosReminderCheck extends TodosEvent {}

class TodosFinishRemind extends TodosEvent {}
