part of 'edit_todo_bloc.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
        EditTodoStatus.loading,
        EditTodoStatus.success,
      ].contains(this);
}

final class EditTodoState extends Equatable {
  const EditTodoState({
    this.status = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
    this.note = '',
  });

  final EditTodoStatus status;
  final Task? initialTodo;
  final String title;
  final String note;

  bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({
    EditTodoStatus? status,
    Task? initialTodo,
    String? title,
    String? note,
  }) {
    return EditTodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [status, initialTodo, title, note];
}
