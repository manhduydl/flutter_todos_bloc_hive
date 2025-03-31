part of 'todos_bloc.dart';

sealed class TodosState extends Equatable {
  const TodosState();
}

final class TodosInitial extends TodosState {
  @override
  List<Object> get props => [];
}

final class TodosLoadedState extends TodosState {
  final List<Task> tasks;

  TodosLoadedState(this.tasks);

  @override
  // TODO: implement props
  List<Object?> get props => [tasks];
}
