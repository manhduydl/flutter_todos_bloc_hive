part of 'todos_bloc.dart';

sealed class TodosState extends Equatable {
  const TodosState();
}

final class TodosInitial extends TodosState {
  @override
  List<Object> get props => [];
}
