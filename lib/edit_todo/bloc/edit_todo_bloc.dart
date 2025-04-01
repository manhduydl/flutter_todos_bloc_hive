import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/task.dart';
import '../../services/todos_api.dart';

part 'edit_todo_event.dart';
part 'edit_todo_state.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  EditTodoBloc({
    required TodosApi todosRepository,
    required Task? initialTodo,
  })  : _todosApi = todosRepository,
        super(
          EditTodoState(
              initialTodo: initialTodo,
              title: initialTodo?.title ?? '',
              note: initialTodo?.note ?? '',
              dueDate: initialTodo?.dueDate),
        ) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditTodoDescriptionChanged>(_onDescriptionChanged);
    on<EditTodoSubmitted>(_onSubmitted);
    on<EditTodoDueDateChanged>(_onDueDateChanged);
  }

  final TodosApi _todosApi;

  void _onTitleChanged(
    EditTodoTitleChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    EditTodoDescriptionChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(note: event.description));
  }

  void _onDueDateChanged(
    EditTodoDueDateChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(dueDate: event.dueDate));
  }

  Future<void> _onSubmitted(
    EditTodoSubmitted event,
    Emitter<EditTodoState> emit,
  ) async {
    emit(state.copyWith(status: EditTodoStatus.loading));
    final todo = (state.initialTodo ?? Task(title: '')).copyWith(
      title: state.title,
      note: state.note,
      dueDate: state.dueDate,
    );

    try {
      await _todosApi.addTask(todo);
      emit(state.copyWith(status: EditTodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }
}
