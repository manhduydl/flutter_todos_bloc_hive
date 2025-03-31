part of 'todos_bloc.dart';

sealed class TodosEvent extends Equatable {
  const TodosEvent();
}

class LoadTodosEvent extends TodosEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
