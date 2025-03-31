import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/task.dart';
import '../../services/todos_api.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosApi _todosApi;

  TodosBloc(this._todosApi) : super(TodosInitial()) {
    on<LoadTodosEvent>((event, emit) async {
      final tasks = await _todosApi.getTasks();
      emit(TodosLoadedState(tasks));
    });
  }
}
